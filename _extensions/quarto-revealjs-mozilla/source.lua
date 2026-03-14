-- source.lua
-- Quarto shortcode: {{< source "Display text" url="https://..." >}}
--
-- Emits a heading separator rule and a styled source/reference line
-- immediately after a slide heading. Designed for use in reveal.js slides.
--
-- Usage examples:
--   {{< source "Kleppmann & Riccomini (2026)" url="https://oreilly.com/..." >}}
--   {{< source "Wikipedia" url="https://en.wikipedia.org/wiki/..." >}}
--   {{< source "own work" >}}
--
-- Output HTML (styled by mozilla.scss):
--   <p class="slide-source">Source: <a href="...">Display text</a></p>
--   <hr class="heading-rule">
--
-- Note: heading-rule.lua injects <hr class="heading-rule"> after every H2
-- that is NOT followed by a {{< source >}} shortcode. For slides that DO use
-- this shortcode, source.lua emits the <hr> here (after the source line) so
-- the order is: slide-source first, then the horizontal rule.
--
-- Why Lua (not CSS alone):
--   The source text and URL are supplied by the author at render time.
--   CSS cannot inject text content from document arguments.
--   The shortcode generates the source line and rule atomically,
--   keeping author syntax clean (one line instead of raw HTML divs).

return {
  ["source"] = function(args, kwargs, meta, raw_args, context)

    -- Only emit HTML for HTML-based output (revealjs is HTML-based)
    if not quarto.doc.isFormat("html") then
      return pandoc.Null()
    end

    -- ── Positional argument: display text ──────────────────────────────────
    local text
    if args[1] then
      text = pandoc.utils.stringify(args[1])
    else
      text = "Source"
    end

    -- ── Named argument: url (optional) ─────────────────────────────────────
    local url = nil
    if kwargs["url"] then
      url = pandoc.utils.stringify(kwargs["url"])
    end

    -- ── Build inner content: linked or plain ───────────────────────────────
    local inner
    if url and url ~= "" then
      -- Escape any quotes in the URL for safety
      local safe_url = url:gsub('"', "&quot;")
      inner = '<a href="' .. safe_url .. '" target="_blank">' .. text .. '</a>'
    else
      inner = text
    end

    -- ── Emit source line then heading rule ────────────────────────────────
    -- heading-rule.lua skips injecting <hr> when a {{< source >}} shortcode
    -- follows the H2, so we emit it here to guarantee correct order:
    -- slide-source first, then the horizontal rule.
    local src  = pandoc.RawBlock("html",
      '<p class="slide-source">Source: ' .. inner .. '</p>')
    local rule = pandoc.RawBlock("html", '<hr class="heading-rule">')

    return pandoc.List({ src, rule })
  end
}
