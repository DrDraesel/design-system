# Lab design system

One visual language for every dashboard in every lab repo. Extracted from the reference dashboard reel (`@_code_and_chill_`, `DemI9wBPRce`, 2026-11-03).

**The look in one line:** warm cream canvas, white cards with hairline borders and soft shadows, an ink-black icon rail, one coral accent, tabular numerals, generous whitespace, almost no chrome.

---

## Files

| File | Purpose |
|---|---|
| `tokens.css` | Colour, type, spacing, radii, elevation as CSS variables. Everything else reads from here. |
| `components.css` | Rail, cards, KPI, tabs, chips, buttons, inputs, tables, list rows, bars, heatmap, charts, badges, drawer, empty states, print + mobile rules. |
| `preview.html` | Living style guide — open it in a browser to see every component together. |
| `lab_theme.py` | The same tokens as a PyQt6 palette + QSS, so NeuroSync matches the web apps. |
| `sync.sh` | Copies the CSS into each app's static folder (single source of truth lives here). |

No fonts, icons, JS frameworks or network calls — system font stack, inline SVG.

---

## Adopt in a web app (3 steps)

1. **Vendor the CSS** into the app's static folder:

   ```bash
   bash C:/Users/GAMEPOWER/projects/design-system/sync.sh runtrack
   ```

2. **Link it before the page's own CSS** and put the class on `<body>`:

   ```html
   <link rel="stylesheet" href="/static/lab-ui/tokens.css">
   <link rel="stylesheet" href="/static/lab-ui/components.css">
   <link rel="stylesheet" href="/static/styles.css">   <!-- app-specific, loaded last -->
   </head>
   <body class="lab-bg">
   ```

3. **Wrap the page** in the shell and move the app's own rules into a thin stylesheet that only overrides layout specifics:

   ```html
   <div class="shell">
     <nav class="rail">…icon links…</nav>
     <main class="main stack">
       <div class="topbar">
         <div class="titles"><h1>Live session</h1><div class="sub">…</div></div>
         <div class="tools">…search / status / primary action…</div>
       </div>
       <section class="card">…</section>
     </main>
   </div>
   ```

**Rule:** never introduce a new colour, radius or shadow in app CSS. If the system lacks something, add it to `tokens.css` here first, then re-sync.

---

## Component map (what replaced what)

| Old pattern | New class |
|---|---|
| ad-hoc `<div class="panel">` boxes | `.card`, `.card > header h2` |
| big number blocks | `.kpi` + `.kpi .v` + `.delta.up/.down` |
| radio button rows / tab strips | `.tabs` (period) and `.filters` (channels/roles) |
| coloured status text | `.badge.ok/.warn/.bad/.info/.plain` with `.dot` |
| plain tables | `table.table` inside `.table-wrap` (sticky header, tabular numerics) |
| card lists | `.list` + `.list-row` + `.avatar.c1…c4` + `.count` |
| bar lists | `.bars` + `.bar-row` (label / track / value) |
| heatmaps | `.heat` + `.heat .cell` + `.heat-legend` (peach → coral → deep red) |
| alerts | `.banner.ok/.warn/.bad` |
| empty screens | `.empty` (icon, title, one line, one action) |

---

## Tokens worth memorising

```
--bg #F7F0E7   --surface #FFFFFF   --ink #1A1A1A   --ink-2 #6E6961
--accent #E8541F   --accent-100 #FBE2D5   --accent-200 #F7C9B2
--ok #1F7A4B / #E4F4E8     --warn #9A5B00 / #FBEEDA     --danger #C8341C / #FBE4DF
--r-lg 18px (cards)   --r-md 14px (controls)   --r-pill 999px (chips/tabs)
--sh-1 soft warm card shadow   --rail-w 72px   --pad-page 28px
```

Type scale: 34 KPI · 26 page title · 17 card title · 14 body · 12.5 secondary · 11 meta. Numbers always `font-variant-numeric: tabular-nums`.

---

## Rules that keep the dashboards usable

1. **One primary action per card.** Secondary actions are `.btn`, destructive is `.btn.danger` and needs a confirm.
2. **Every number carries its state**: measured, estimated, or invalid. Use `.badge` — never a green pill on unverified data.
3. **No colour without meaning.** Coral = the one accent / the series in focus. Green/amber/red only for state.
4. **Density over decoration.** 16 px card gaps, 20-24 px card padding, no gradients except the page background, no icons-in-rainbow.
5. **Minimum 1366×768.** The responsive rules collapse the rail to a bottom bar under 820 px; test at 1280 too.
6. **Print:** `.rail` and `.btn` hide automatically; cards avoid page breaks.

---

## Desktop (PyQt6)

```python
import sys
from PyQt6.QtWidgets import QApplication
sys.path.insert(0, r"C:/Users/GAMEPOWER/projects/design-system")
from lab_theme import apply_theme, C

app = QApplication(sys.argv)
apply_theme(app)            # call once, before building windows
```

Use object names for semantic text: `H1`, `H2`, `Muted`, `Kpi`, `BadgeOk`, `BadgeWarn`, `BadgeBad`; `Primary` / `Danger` on buttons; wrap groups in `QFrame(objectName="Card")`.
