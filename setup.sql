-- Mapping MX Mems — Supabase setup
-- Paste this whole file into the Supabase SQL Editor and click Run.
-- Before running, change the email address at the very bottom (the moderators insert).
-- Safe to run more than once.

-- ---------------------------------------------------------------------------
-- Moderators: people allowed to approve, hide and delete memories.
-- Nobody can read this table through the site; only the is_moderator() check uses it.
-- ---------------------------------------------------------------------------
create table if not exists public.moderators (
  email text primary key,
  added_at timestamptz not null default now()
);
alter table public.moderators enable row level security;

create or replace function public.is_moderator()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.moderators m
    where m.email = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
grant execute on function public.is_moderator() to anon, authenticated;

-- ---------------------------------------------------------------------------
-- Memories: one row per pin.
-- ---------------------------------------------------------------------------
create table if not exists public.memories (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  status text not null default 'pending' check (status in ('pending', 'approved', 'hidden')),
  x double precision not null check (x >= 0 and x <= 1),
  y double precision not null check (y >= 0 and y <= 1),
  place text not null default '' check (char_length(place) <= 60),
  title text not null check (char_length(title) between 1 and 80),
  story text not null check (char_length(story) between 1 and 1200),
  name text not null check (char_length(name) between 1 and 60),
  class_year text not null default '' check (class_year ~ '^([0-9]{4})?$'),
  photo_path text check (photo_path is null or photo_path ~ '^photos/[A-Za-z0-9._-]{1,120}$'),
  caption text not null default '' check (char_length(caption) <= 140),
  map_version text not null default '' check (char_length(map_version) <= 80)
);
create index if not exists memories_status_created_idx on public.memories (status, created_at desc);
alter table public.memories enable row level security;

drop policy if exists "memories: read approved" on public.memories;
create policy "memories: read approved"
  on public.memories for select to anon, authenticated
  using (status = 'approved' or public.is_moderator());

drop policy if exists "memories: anyone can submit" on public.memories;
create policy "memories: anyone can submit"
  on public.memories for insert to anon, authenticated
  with check (status = 'pending');

drop policy if exists "memories: moderators update" on public.memories;
create policy "memories: moderators update"
  on public.memories for update to authenticated
  using (public.is_moderator()) with check (public.is_moderator());

drop policy if exists "memories: moderators delete" on public.memories;
create policy "memories: moderators delete"
  on public.memories for delete to authenticated
  using (public.is_moderator());

grant select, insert on public.memories to anon;
grant select, insert, update, delete on public.memories to authenticated;

-- ---------------------------------------------------------------------------
-- Photos: a public bucket. Anyone can add a photo under photos/; only moderators delete.
-- 10 MB per file, images only.
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('memories', 'memories', true, 10485760, array['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "memories photos: anyone can upload" on storage.objects;
create policy "memories photos: anyone can upload"
  on storage.objects for insert to anon, authenticated
  with check (bucket_id = 'memories' and (storage.foldername(name))[1] = 'photos');

drop policy if exists "memories photos: public read" on storage.objects;
create policy "memories photos: public read"
  on storage.objects for select to anon, authenticated
  using (bucket_id = 'memories');

drop policy if exists "memories photos: moderators delete" on storage.objects;
create policy "memories photos: moderators delete"
  on storage.objects for delete to authenticated
  using (bucket_id = 'memories' and public.is_moderator());

-- ---------------------------------------------------------------------------
-- Moderators. CHANGE THIS EMAIL to yours before running. Add more rows later
-- in Table Editor → moderators (one email per row, lowercase).
-- ---------------------------------------------------------------------------
insert into public.moderators (email) values (lower('you@mxschool.edu'))
on conflict (email) do nothing;
