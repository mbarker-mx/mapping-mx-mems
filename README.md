# Mapping MX Mems

Middlesex alumni memories, pinned to the spot on campus where they happened. Visitors tap a spot on the illustrated campus map, write a short story, add a photo, and send it in. Memories go live once a moderator approves them.

The site is a single page hosted on GitHub Pages. Memories and photos live in a free Supabase project that you control.

## What's in this folder

| File | What it is |
| --- | --- |
| `index.html` | The whole site. You shouldn't need to touch it. |
| `config.js` | The only file you edit: your Supabase URL and publishable key, the site name, the map and the list of labeled places. |
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
   - **Publishable key** (starts with `sb_publishable_`; older projects call it the **anon public** key) → `supabaseAnonKey`

   The publishable key is designed to be public. The rules created by `setup.sql` decide what it can do: read approved memories, submit new ones as pending, upload a photo. Nothing else. The **Secret key** on the same page must never go in `config.js` or anywhere on GitHub: it bypasses every rule.

### 2. Publish on GitHub Pages

1. On github.com, create a new **public** repository called `mapping-mx-mems` (no README, no .gitignore).
2. Upload every file in this folder, including `supabase/setup.sql`, `.nojekyll` and your edited `config.js`. Commit.
3. In the repository, open **Settings → Pages**. Under *Build and deployment* choose **Deploy from a branch**, branch `main`, folder `/ (root)`. Save.
4. After a minute the page shows the site address, usually `https://YOUR-USERNAME.github.io/mapping-mx-mems/`. Open it: the map should appear and the tray should say "No memories on the map yet". If it says "Not connected to the database yet", re-check step 1.4.

### 3. Create the moderator login

Moderators sign in with an email address and a password. No email sending is involved, so nothing else needs configuring.

1. In Supabase open **Authentication → Users**, click **Add user → Create new user**.
2. Enter the same email you put in `setup.sql`, choose a password, and tick **Auto Confirm User**. Create.
3. On the site, click **Moderators** and sign in with that email and password. The tray now shows **Pending / Live / Hidden** chips.

A login only gets moderator powers if its email is also in the `moderators` table (that's what the line at the end of `setup.sql` did). To add a colleague later, do both: add their email to the table (Table Editor → moderators → Insert row, lowercase) and create a user for them as above.

Forgotten password: in **Authentication → Users**, delete that user and create it again with a new password. Their row in the moderators table stays, so nothing else changes.

## Moderating

- Open **Moderators** and sign in. Pending memories are listed first in the tray and drawn as amber pins on the map.
- Open a memory and click **Approve** (goes live), **Hide** (off the public map, kept) or **Delete** (gone, photo included).
- **Download all memories (CSV)** in the Moderators panel gives you a spreadsheet with every memory and photo link. Do this now and then as a backup.
- To add another moderator: in Supabase, **Table Editor → moderators → Insert row** (email in lowercase), then **Authentication → Users → Add user** to give them a password.
- Everything can also be done in Supabase's **Table Editor** (table `memories`, column `status`) if the site is ever unavailable.

## Changing things

- **Site name, tagline, footer line:** `config.js`, the `site` section.
- **Replacing the map:** put the new image in the folder, set `src`, `w` and `h` in `config.js` (width and height in pixels), and change `version` to a new label. Pins placed on an earlier map are then flagged "old map" so a moderator can check them. Keep the same framing if you can, so existing pins and place labels stay put.
- **Labeled places:** `config.js`, the `legend` list. `x` and `y` are fractions of the image width and height, from 0 to 1. Hovering a marker on the map shows its name; a pin dropped within about 60 pixels of a marker fills in "Where on campus" automatically.
- **Custom domain** (for example `mems.mxschool.edu`): GitHub **Settings → Pages → Custom domain**, then ask whoever manages the school's DNS for a CNAME to `YOUR-USERNAME.github.io`.

## Limits and good to know

- Supabase's free tier gives 500 MB of database and 1 GB of photo storage; photos are resized to 1600 px before upload, so that is thousands of memories. The project pauses after a week without any visits; opening the site wakes it, or upgrade the project to keep it always on.
- Submissions are open to anyone who has the link. The approval queue, a hidden honeypot field and a short pause between submissions keep spam out of sight; nothing shows publicly until a moderator approves it.
- Photos are public once approved and reachable by their link. Don't approve anything you wouldn't put on the school website.
- Contributors can't edit their own memory after sending it. If someone asks for a change, a moderator can edit the row in Supabase's Table Editor.
