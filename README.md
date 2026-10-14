# Mapping MX Mems

Middlesex alumni memories, pinned to the spot on campus where they happened. Visitors tap a spot on the illustrated campus map, write a short story, add a photo, and send it in. Memories go live once a moderator approves them.

The site is a single page hosted on GitHub Pages. Memories and photos live in a free Supabase project that you control.

## What's in this folder

| File | What it is |
| --- | --- |
| `index.html` | The whole site. You shouldn't need to touch it. |
| `config.js` | The only file you edit: your Supabase URL and key, the site name, the map and the list of labeled places. |
| `campus-map.png` | The illustrated campus map. Pins are placed on this image. |
| `supabase/setup.sql` | Creates the database table, the photo bucket and the access rules. Run once. |
| `.nojekyll` | Tells GitHub Pages to serve the files as they are. |

## Setup (about ten minutes)

### 1. Create the Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up with a school email. Create a new project (any name, choose the region closest to Concord, e.g. US East).
2. Open **SQL Editor** → **New query**. Paste the contents of `supabase/setup.sql`.
3. In the last lines of the script, replace `you@mxschool.edu` with your own email address. Click **Run**. It should finish with "Success".
4. Open **Project Settings → API**. Copy two values into `config.js`:
   - **Project URL** → `supabaseUrl`
   - **anon public** key → `supabaseAnonKey`

   The anon key is designed to be public. The rules created by `setup.sql` decide what it can do: read approved memories, submit new ones as pending, upload a photo. Nothing else.

### 2. Publish on GitHub Pages

1. On github.com, create a new **public** repository called `mapping-mx-mems` (no README, no .gitignore).
2. Upload every file in this folder, including `supabase/setup.sql`, `.nojekyll` and your edited `config.js`. Commit.
3. In the repository, open **Settings → Pages**. Under *Build and deployment* choose **Deploy from a branch**, branch `main`, folder `/ (root)`. Save.
4. After a minute the page shows the site address, usually `https://YOUR-USERNAME.github.io/mapping-mx-mems/`. Open it: the map should appear and the tray should say "No memories on the map yet". If it says "Not connected to the database yet", re-check step 1.4.

### 3. Let moderators sign in

Moderators sign in with an emailed link, so Supabase has to know where the site lives.

1. In Supabase open **Authentication → URL Configuration**.
2. Set **Site URL** to your Pages address from step 2.4, and add the same address under **Redirect URLs**. Save.
3. On the site, click **Moderators**, enter the email you put in `setup.sql`, and click the link in the email on the same device. You'll land back on the site signed in; the tray now shows **Pending / Live / Hidden** chips.

Supabase's built-in email sender allows only a few sign-in emails per hour, which is fine for moderators. If you ever need more, add your school's SMTP details under **Authentication → SMTP Settings**.

## Moderating

- Open **Moderators** and sign in. Pending memories are listed first in the tray and drawn as amber pins on the map.
- Open a memory and click **Approve** (goes live), **Hide** (off the public map, kept) or **Delete** (gone, photo included).
- **Download all memories (CSV)** in the Moderators panel gives you a spreadsheet with every memory and photo link. Do this now and then as a backup.
- To add another moderator: in Supabase, **Table Editor → moderators → Insert row**, email in lowercase. They then sign in the same way.
- Everything can also be done in Supabase's **Table Editor** (table `memories`, column `status`) if the site is ever unavailable.

## Changing things

- **Site name, tagline, footer line:** `config.js`, the `site` section.
- **Replacing the map:** put the new image in the folder, set `src`, `w` and `h` in `config.js` (width and height in pixels), and change `version` to a new label. Pins placed on an earlier map are then flagged "old map" so a moderator can check them. Keep the same framing if you can, so existing pins and place labels stay put.
- **Labeled places:** `config.js`, the `legend` list. `x` and `y` are fractions of the image width and height, from 0 to 1. Hovering a marker on the map shows its name; a pin dropped within about 60 pixels of a marker fills in "Where on campus" automatically.
- **Custom domain** (for example `mems.mxschool.edu`): GitHub **Settings → Pages → Custom domain**, then ask whoever manages the school's DNS for a CNAME to `YOUR-USERNAME.github.io`. Update the Site URL in Supabase afterwards.

## Limits and good to know

- Supabase's free tier gives 500 MB of database and 1 GB of photo storage; photos are resized to 1600 px before upload, so that is thousands of memories. The project pauses after a week without any visits; opening the site wakes it, or upgrade the project to keep it always on.
- Submissions are open to anyone who has the link. The approval queue, a hidden honeypot field and a short pause between submissions keep spam out of sight; nothing shows publicly until a moderator approves it.
- Photos are public once approved and reachable by their link. Don't approve anything you wouldn't put on the school website.
- Contributors can't edit their own memory after sending it. If someone asks for a change, a moderator can edit the row in Supabase's Table Editor.
