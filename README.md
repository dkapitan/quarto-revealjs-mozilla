# quarto-revealjs-mozilla

A [Quarto](https://quarto.org) extension for [reveal.js](https://revealjs.com) presentations in the [Mozilla brand](https://mozilla.design/mozilla/) style: sand/light grey background, warm red accent color, Zilla Slab headings and Fira Sans body text.

## Quick start

```bash
quarto use template dkapitan/quarto-revealjs-mozilla
```

This copies `template.qmd` and the `_extensions/` directory into your working directory. Render with:

```bash
quarto render template.qmd
```

## Installation (existing project)

```bash
quarto add dkapitan/quarto-revealjs-mozilla
```

Then set the format in your document YAML:

```yaml
format: quarto-revealjs-mozilla-revealjs
```

## Title slide

The title slide is fully customised. All fields are optional except `title`.

```yaml
---
title: "Your presentation title<br>second line here"
subtitle: "Optional subtitle"
author: "Your Name"
email: "you@example.com"
website: "https://yourwebsite.com"
phone: "+00 (0)0 0000 0000"
github: "https://github.com/yourusername"
linkedin: "https://linkedin.com/in/yourusername"
institution: "Your Institution"
institution-url: "https://yourinstitution.org"
img-attribution: "Photographer / source / licence"
img-attribution-url: "https://source-url.example.com"
format: quarto-revealjs-mozilla-revealjs
title-slide-attributes:
  data-background-image: "images/cover.jpg"
  data-background-opacity: "0.5"
---
```

Use `<br>` in the `title` field to break it across two lines.

The `img-attribution` / `img-attribution-url` fields add a small attribution line in the bottom-right corner of the title slide, useful when using a licensed cover photograph.

## Shortcode: `{{< source >}}`

Place a source citation below any slide heading:

```markdown
## Slide heading
{{< source "Author (Year)" url="https://doi.org/..." >}}
```

This renders a thin horizontal rule followed by a small italic citation. The `url=` argument is optional — omit it for unpublished or original work:

```markdown
{{< source "own work" >}}
```

## Slide layouts

### Standard content slide

```markdown
## Heading
{{< source "Citation" url="https://..." >}}

- Bullet one
- Bullet two
```

### Two-column layout

```markdown
:::: {.columns}
::: {.column width="60%"}
Left content
:::
::: {.column width="40%"}
Right content
:::
::::
```

### Full-width image (fills available height)

```markdown
## Heading

![](images/figure.png){.r-stretch}
```

### Background image on a slide

```markdown
## Heading {background-image="images/photo.jpg" background-opacity="0.4"}
```

### Large centred text over background (section divider)

```markdown
## {background-image="images/photo.jpg" background-opacity="0.4" .center}

::: {.r-fit-text}
Section title
:::
```

### Card grid (3-up)

```markdown
::: {.card-grid}
::: {.card}
**Card title**

Card body text.
:::
::: {.card}
**Card title**

Card body text.
:::
::: {.card}
**Card title**

Card body text.
:::
:::
```

> **Note:** Do not use `###` headings inside cards. In revealjs, headings inside fenced divs become sub-slides (`<section>`), breaking the grid. Use bold paragraphs (`**Title**`) instead.

### Two-line headings

Use `<br>` directly in the heading:

```markdown
## A long heading that needs<br>two lines
```

## Design tokens

The theme is based on the [Mozilla brand guidelines](https://mozilla.design/mozilla/), using Mozilla's official typeface (Zilla Slab) and colour palette. Colours and font configuration are defined in `_brand.yml`; sizing and layout overrides live in `_extensions/quarto-revealjs-mozilla/mozilla.scss`.

### Colours

All colours from the [Mozilla colour palette](https://mozilla.design/mozilla/#color) are defined as named palette entries in `_brand.yml`:

| Name | Hex | Mozilla palette |
|:-----|:----|:----------------|
| `warm-red` | `#ff4f5e` | Primary — accent, links, controls |
| `lemon-yellow` | `#fff44f` | Primary |
| `neon-blue` | `#00ffff` | Primary |
| `neon-green` | `#54ffbd` | Primary |
| `dark-purple` | `#6e008b` | Primary |
| `black` | `#000000` | Primary |
| `white` | `#ffffff` | Primary |
| `dark-green` | `#005e5e` | Secondary |
| `dark-blue` | `#00458b` | Secondary |
| `dark-grey` | `#959595` | Secondary |
| `light-grey` | `#e7e5e2` | Secondary |
| `sand` | `#faf8d9` | Theme addition — slide background |
| `near-black` | `#111111` | Theme addition — body text |

### Typography

| Element | Font | Source |
|:--------|:-----|:-------|
| Headings | Zilla Slab (600) | [Mozilla brand typeface](https://mozilla.design/mozilla/#typography) / Google Fonts |
| Title H1 | Zilla Slab Highlight | Mozilla brand typeface / Google Fonts |
| Body / links | Fira Sans | Google Fonts |
| Code | Fira Code | Google Fonts |

### Slide dimensions

| Property | Value |
|:---------|:------|
| Dimensions | 1280 × 720 px |
| Transition | fade |

## Example

See [`example.qmd`](example.qmd) for a full demo covering all major layout patterns.

```bash
quarto render example.qmd
```

## Requirements

- Quarto ≥ 1.4.0
- An internet connection when rendering (Google Fonts are loaded from CDN)

## Licence

[MIT](LICENSE)
