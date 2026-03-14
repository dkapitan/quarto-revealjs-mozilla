# AGENTS.md — quarto-revealjs-mozilla

Project context for AI coding agents. Keep this file up to date when making significant changes.

---

## Goal

A Quarto starter template that produces reveal.js presentations matching Mozilla brand guidelines.

Install via: `quarto use template dkapitan/quarto-revealjs-mozilla`  
Format key: `quarto-revealjs-mozilla-revealjs`

---

## Feature implementation priority

When implementing or choosing how to express a feature, follow this priority order:

1. **Standard Quarto features** — use built-in options first
2. **`_brand.yml`** — colours, fonts, logo, semantic roles
3. **SCSS** (`mozilla.scss`) — sizing, layout, component rules not expressible in `_brand.yml`
4. **Lua filters** — AST manipulation only when all above are insufficient

---

## Brand tokens

| Token | Value | Role |
|:------|:------|:-----|
| `light-grey` | `#e7e5e2` | Slide background (semantic role `background` in `_brand.yml`) |
| `warm-red` | `#ff4f5e` | Accent: links, controls, list markers, progress bar |
| `near-black` | `#111111` | Body text (semantic role `foreground`) |
| Body font | Fira Sans | Set in `_brand.yml` |
| Heading font | Zilla Slab | Set in `_brand.yml` |
| Cover H1 font | Zilla Slab Highlight | Override in `mozilla.scss` (not expressible in `_brand.yml`) |
| Code/link font | Fira Code | Set in `_brand.yml` |
| Logo | `images/logo-eaisi.png` | `_brand.yml` → `logo.small` |

---

## File map

```
├── _brand.yml                        Brand colours, fonts, semantic roles, logo
├── template.qmd                      Starter template (copied on quarto use template)
├── example.qmd                       Example presentation (rendered to example.html)
├── AGENTS.md                         This file
├── README.md                         User-facing documentation
├── images/
│   ├── logo-eaisi.png                Source logo (referenced by _brand.yml logo.small)
│   └── talking-to-ai.jpg             Cover image used in example.qmd
└── _extensions/quarto-revealjs-mozilla/
    ├── _extension.yml                Format config; registers logo.lua + heading-rule.lua filters + source.lua shortcode
    ├── mozilla.scss                  Sizing, layout, component CSS
    ├── source.lua                    {{< source "text" url="..." >}} shortcode — emits slide-source line only
    ├── heading-rule.lua              Injects <hr class="heading-rule"> after every H2 heading
    ├── logo.lua                      Reads _brand.yml logo and injects institution-logo metadata for title-slide.html
    └── title-slide.html              Pandoc partial: social icons, institution logo, img-attribution
```

---

## Key CSS selectors

| Element | Selector |
|:--------|:---------|
| Menu button | `.reveal .slide-menu-button` |
| Nav arrows | `.reveal .controls` |
| Slide number | `.slide-number, .reveal.has-logo .slide-number` (combined selector) |
| Slide logo (non-title) | `.slide-logo` (fixed, bottom-left) |
| Title slide logo | `.reveal .slides section.title-slide .institution-logo` (absolute, bottom-right) |
| Hide slide# on title | `.no-slide-number .slide-number { display: none }` via `data-state="no-slide-number"` |
| Suppress logo on title | `.no-logo .slide-logo { display: none }` via `data-state="no-slide-number no-logo"` on title section |

---

## Layout positions

- **Menu button** — `fixed; top: 6px; right: 0` (flex, pointer-events: none; children pointer-events: auto)
- **Navigation controls** — `fixed; bottom: 28px; right: 8px` (above slide number)
- **Slide number** — `bottom: 6px; right: 10px` (enforced via combined selector `.slide-number, .reveal.has-logo .slide-number`)
- **Slide logo** — `fixed; bottom: 0; left: 10px`
- **Institution logo** — `absolute; bottom: 16px; right: 16px` (title slide only)

---

## Known gotchas

- **Pandoc template nesting:** `$if$/$else$/$endif$` must be flat — one directive per line
- **Filter registration:** Filters for format extensions must be under `contributes.formats.revealjs.filters` in `_extension.yml`, not at the top-level `contributes.filters` or under `common`
- **Lua working directory:** Lua filters run from the document directory, not the project root. `logo.lua` searches for `_brand.yml` at `./` then `../`, and prepends `../` to the logo path when found via parent
- **Logo path:** `_brand.yml` → `logo.small: images/logo-eaisi.png` is relative to project root; when rendered from a subdirectory, the path is auto-prefixed with `../` by `logo.lua`
- **Content-slide logo:** Provided natively by Quarto's built-in `logo:` mechanism (auto-sourced from `_brand.yml` `logo.small`). `logo.lua` only handles injecting the logo path into metadata for the title-slide partial — no AST injection
- **`source.lua` shortcode:** Emits `<p class="slide-source">` only. The `<hr class="heading-rule">` is injected globally by `heading-rule.lua`, not by this shortcode.
- **`heading-rule.lua` filter:** Injects `<hr class="heading-rule">` after every level-2 heading in the document AST. Runs only for `revealjs` output. Registered under `contributes.formats.revealjs.filters` in `_extension.yml`.
- **Title slide:** Uses a full Pandoc partial (`title-slide.html`). `data-state="no-slide-number no-logo"` hides the slide number (`.no-slide-number .slide-number { display: none }`) and suppresses the native `.slide-logo` (`.no-logo .slide-logo { display: none }`) so only the `institution-logo` appears
- **Background colour from `_brand.yml`:** `color.background: light-grey` in `_brand.yml` correctly propagates through `$body-bg` → `$backgroundColor` → `--r-background-color: #e7e5e2` in the compiled CSS. No SCSS override is needed — the brand layer sets this correctly before all framework defaults. Confirmed via `QUARTO_SAVE_SCSS` debug output and inspecting the compiled theme CSS.
- **Brand variables available in `scss:defaults`:** Quarto injects `_brand.yml` typography and colour variables (`$link-color`, `$body-color`, `$code-color`, `$font-family-monospace`, etc.) **before** `/*-- scss:defaults --*/` runs. All `mozilla.scss` defaults wire directly from these brand variables (no literal fallback values needed). The `$accent: $link-color !default` wiring is done in `scss:defaults`, not in `scss:rules`.
- **All colour literals replaced:** `mozilla.scss` uses only Sass variables — no hardcoded hex values for brand colours anywhere. `$accent: $link-color !default` in `scss:defaults` wires accent to brand primary. `$light-bg-code-color: $code-color !default` picks up `dark-purple` from brand monospace colour. Blockquote background uses `rgba($accent, 0.05)`.
- **`controls` colour:** `.reveal .controls` sets `color: $accent` directly on the container — no separate `.controls button` rule needed (inherited by child buttons).
- **Links inherit Fira Sans:** No explicit `font-family` rule on links — they inherit the body font (`--r-main-font: Fira Sans`) set globally on `.reveal`. `$font-monospace` Sass variable (= `$font-family-monospace, monospace`) is used for all Fira Code references (slide number, contact info, attribution, social icons) instead of string literals.
- **Card grid — no `###` headings inside cards:** In revealjs, headings inside fenced divs (`::: {.card}`) are promoted to `<section>` elements by Pandoc, breaking the grid layout. Use bold paragraphs (`**Title**`) for card titles instead. The `.card p:first-child` rule in `mozilla.scss` styles the first paragraph as a title.

---

## Rendering

```bash
quarto render example.qmd
quarto render template.qmd
```

Both should render without errors. The example output lives at `example.html`.

To debug SCSS variable resolution:
```bash
QUARTO_SAVE_SCSS=/tmp/quarto-debug quarto render example.qmd
# Inspect /tmp/quarto-debug-1.scss — look for brand layer defaults and final css-vars annotation
```
