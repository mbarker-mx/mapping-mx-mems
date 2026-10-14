// Mapping MX Mems — site configuration.
// This is the only file you need to edit. Keep the quotes; change the values.

window.MX_CONFIG = {
  // 1) From Supabase: Project Settings → API → "Project URL" and the "anon public" key.
  //    The anon key is meant to be public; the access rules in supabase/setup.sql protect the data.
  supabaseUrl: "https://YOUR-PROJECT-REF.supabase.co",
  supabaseAnonKey: "YOUR-ANON-PUBLIC-KEY",

  site: {
    name: "Mapping MX Mems",
    tagline: "Middlesex alumni memories, pinned to the spot on campus where they happened",
    // Shown at the bottom of the map.
    footer: "Middlesex School · 1400 Lowell Road, Concord · laid out around the Circle by the Olmsted Brothers from 1902"
  },

  map: {
    // The campus map image, kept in this repository next to index.html.
    src: "campus-map.png",
    w: 1714,
    h: 813,
    // Change this whenever you replace the image with a different framing; pins placed
    // on an earlier version are then flagged so a moderator can check them.
    version: "illustrated-map-2026",
    // Optional credit line shown in the map footer (for example "Imagery © Google").
    credit: "",
    // Labeled places. x and y are fractions of the image width and height (0 to 1).
    // Hovering a marker shows the name; a pin dropped near one fills in "Where on campus".
    legend: [
      { k: "1", name: "Head of School's House", x: 0.8145, y: 0.8278 },
      { k: "2", name: "Landry House", x: 0.8273, y: 0.6642 },
      { k: "3", name: "Higginson House", x: 0.7106, y: 0.6839 },
      { k: "4", name: "LeBaron Briggs House", x: 0.5566, y: 0.7417 },
      { k: "5", name: "Memorial Chapel in Lambert Hall", x: 0.4469, y: 0.6925 },
      { k: "6", name: "Robert Winsor House", x: 0.3466, y: 0.5658 },
      { k: "7", name: "Kravis House", x: 0.2497, y: 0.4711 },
      { k: "8", name: "Orr Gymnasium", x: 0.2007, y: 0.3260 },
      { k: "9", name: "Elizabeth Atkins Athletic Center", x: 0.2544, y: 0.2202 },
      { k: "10", name: "Atkins Cage", x: 0.3606, y: 0.2091 },
      { k: "11", name: "Landry Center", x: 0.2847, y: 0.3137 },
      { k: "12", name: "Student Center", x: 0.3279, y: 0.3616 },
      { k: "13", name: "Ware Hall / Cruz Health Center / Business Office", x: 0.4067, y: 0.4330 },
      { k: "14", name: "Atkins House", x: 0.4072, y: 0.2780 },
      { k: "15", name: "Peabody House", x: 0.4912, y: 0.3924 },
      { k: "16", name: "Rachel Carson Music & Campus Center", x: 0.4936, y: 0.2608 },
      { k: "17", name: "Clay Centennial Center", x: 0.5414, y: 0.2989 },
      { k: "18", name: "Administration / Admissions / Eliot Hall / Head of School's Office", x: 0.5519, y: 0.4330 },
      { k: "19", name: "Bancroft Courtyard", x: 0.6202, y: 0.3985 },
      { k: "20", name: "Danoff Center for Visual Arts / Bass Arts Pavilion", x: 0.6307, y: 0.3186 },
      { k: "21", name: "Alumni & Development / Warburg Library", x: 0.7188, y: 0.3579 },
      { k: "22", name: "Hallowell House", x: 0.6453, y: 0.4895 },
      { k: "23", name: "Bryant-Paine House", x: 0.7386, y: 0.4920 },
      { k: "24", name: "Clay House", x: 0.8436, y: 0.4428 },
      { k: "25", name: "Locke Boat House", x: 0.9685, y: 0.3961 },
      { k: "A", name: "Athletic Fields", x: 0.3197, y: 0.8462 },
      { k: "E", name: "East Fields & Tennis Courts", x: 0.6978, y: 0.1316 },
      { k: "F", name: "Faculty Home", x: 0.9656, y: 0.7417 },
    ]
  }
};
