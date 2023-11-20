-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.default_prog = { 'ubuntu' }
config.color_scheme = 'nord'
config.font = wezterm.font 'MesloLGS Nerd Font'
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.96
config.text_background_opacity = 0.7

-- and finally, return the configuration to wezterm
return config
