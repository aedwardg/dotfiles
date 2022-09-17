local colors_name = "nordbones_custom"
vim.g.colors_name = colors_name

local lush = require "lush"
local hsluv = lush.hsluv
local util = require "zenbones.util"
-- local palette = require "nordbones.palette.dark"

local base = {
  nord0 = hsluv "#2e3440",
  nord1 = hsluv "#3b4252",
  nord2 = hsluv "#434c5e",
  nord3 = hsluv "#4c566a",
  nord4 = hsluv "#d8dee9",
  nord5 = hsluv "#e5e9f0",
  nord6 = hsluv "#eceff4",
  nord7 = hsluv "#8fbcbb",
  nord8 = hsluv "#88c0d0",
  nord9 = hsluv "#81a1c1",
  nord10 = hsluv "#5e81ac",
  nord11 = hsluv "#bf616a",
  nord12 = hsluv "#d08770",
  nord13 = hsluv "#ebcb8b",
  nord14 = hsluv "#a3be8c",
  nord15 = hsluv "#b48ead",
}

local bg = vim.opt.background:get()

local palette = util.palette_extend({
  bg = base.nord0,
  fg = base.nord6,
  rose = base.nord11,
  leaf = base.nord14,
  wood = base.nord12,
  water = base.nord7,
  blossom = base.nord15,
  sky = base.nord8,
}, bg)

local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))
local light_blue = palette.bg.saturation(46).lightness(palette.bg.l + 18)
local mid_grey = base.nord1.lightness(38)

local specs = lush.extends({ base_specs }).with(function()
  ---@diagnostic disable: undefined-global
  return {
    Number { fg = palette.blossom, gui = "italic" },
    Identifer { fg = palette.fg },
    Function { fg = base.nord8 },
    Statement { fg = base.nord9 },
    Type { fg = base.nord10 },
    -- String { base_specs.Constant, fg = palette.leaf }, --   a string constant: "this is a string"
    LspReferenceText { bg = mid_grey }, -- used for highlighting "text" references
    LspReferenceRead { LspReferenceText }, -- used for highlighting "read" references
    LspReferenceWrite { LspReferenceText }, -- used for highlighting "write" references
    -- Search { base_specs.Search, bg = palette.blossom.lightness(palette.bg.l + 25) }, -- Last search pattern highlighting (see 'hlsearch').	Also used for similar items that need to stand out.
    MatchParen { base_specs.Search, bg = palette.blossom.lightness(palette.bg.l + 25) },
    Search { base_specs.Search, bg = light_blue }, -- Last search pattern highlighting (see 'hlsearch').	Also used for similar items that need to stand out.
    IncSearch { base_specs.IncSearch, bg = light_blue.lightness(50) }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- IncSearch { base_specs.IncSearch, bg = palette.blossom.lightness(palette.bg.l + 56) }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  }
end)

lush(specs)
