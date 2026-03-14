-- logo.lua
-- Reads logo.small (or logo.medium/path) from _brand.yml and injects it as
-- `institution-logo` metadata if the user has not already set it.
-- title-slide.html uses $institution-logo$ to render the logo on the title slide.
--
-- Content-slide logos are handled natively by Quarto's built-in logo: option,
-- which automatically picks up logo.small from _brand.yml. No AST injection needed.

local function read_brand_logo()
  local candidates = {
    { path = "_brand.yml",    prefix = ""    },
    { path = "../_brand.yml", prefix = "../" },
  }
  local content, prefix = nil, ""
  for _, c in ipairs(candidates) do
    local f = io.open(c.path, "r")
    if f then
      content = f:read("*a")
      prefix  = c.prefix
      f:close()
      break
    end
  end
  if not content then return nil end

  local function prepend(p)
    if prefix == "" or p:match("^/") or p:match("^https?://") then return p end
    return prefix .. p
  end

  -- "logo: path/to/file.png"  (scalar, not a mapping)
  local scalar = content:match("\nlogo:%s+([^%s{#\n][^\n]*)")
  if scalar then
    scalar = scalar:match("^%s*(.-)%s*$")
    if scalar ~= "" and not scalar:match("^%a[%w%-]+:") then
      return prepend(scalar)
    end
  end

  -- "logo:\n  small: path/to/file.png"
  local small = content:match("\nlogo:[^\n]*\n%s+small:%s*([^\n#]+)")
  if small then return prepend(small:match("^%s*(.-)%s*$")) end

  -- "logo:\n  medium: path/to/file.png"
  local medium = content:match("\nlogo:[^\n]*\n%s+medium:%s*([^\n#]+)")
  if medium then return prepend(medium:match("^%s*(.-)%s*$")) end

  -- "logo:\n  path: path/to/file.png"
  local path = content:match("\nlogo:[^\n]*\n%s+path:%s*([^\n#]+)")
  if path then return prepend(path:match("^%s*(.-)%s*$")) end

  return nil
end

function Meta(meta)
  -- Only inject if user has not set institution-logo manually
  if meta["institution-logo"] then return nil end
  local logo = read_brand_logo()
  if logo then
    meta["institution-logo"] = pandoc.MetaString(logo)
    return meta
  end
end

return { { Meta = Meta } }
