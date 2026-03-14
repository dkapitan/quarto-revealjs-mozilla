-- heading-rule.lua
-- Pandoc Lua filter: inject <hr class="heading-rule"> after every H2.
--
-- In a reveal.js presentation each H2 becomes a slide heading. This filter
-- inserts a thin horizontal rule immediately after every H2 so that all
-- content slides have a consistent visual separator below the heading,
-- regardless of whether the {{< source >}} shortcode is used on that slide.
--
-- Ordering note: extension Lua filters run BEFORE shortcode expansion.
-- When a {{< source >}} shortcode follows an H2, it appears in the AST as a
-- Para containing a single Span with __quarto_custom_type == "Shortcode".
-- In that case we skip injecting the <hr> here — source.lua emits it after
-- expanding the shortcode (slide-source line first, then <hr>).
--
-- The rule is styled by .heading-rule in mozilla.scss.

-- Returns true if a block is a Para whose sole inline is a Quarto shortcode Span.
local function is_shortcode_para(block)
  if block.t ~= "Para" then return false end
  if #block.content ~= 1 then return false end
  local inline = block.content[1]
  if inline.t ~= "Span" then return false end
  return inline.attr.attributes["__quarto_custom_type"] == "Shortcode"
end

local rule = pandoc.RawBlock("html", '<hr class="heading-rule">')

function Pandoc(doc)
  if not quarto.doc.isFormat("revealjs") then
    return nil
  end

  local blocks = pandoc.List()
  local i = 1
  while i <= #doc.blocks do
    local block = doc.blocks[i]
    blocks:insert(block)
    if block.t == "Header" and block.level == 2 then
      local next = doc.blocks[i + 1]
      if next and is_shortcode_para(next) then
        -- A {{< source >}} shortcode follows: skip injecting <hr> here.
        -- source.lua will emit slide-source + <hr> after shortcode expansion.
      else
        -- No shortcode: inject <hr> immediately after the heading.
        blocks:insert(rule)
      end
    end
    i = i + 1
  end
  doc.blocks = blocks
  return doc
end
