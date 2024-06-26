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
config.color_scheme = 'Builtin Tango Dark'

config.font = wezterm.font "FiraMono Nerd font", {weight="Light", stretch="Normal", style="Normal"}
config.colors = {cursor_bg = 'rgba(100, 100, 100, 0)', cursor_fg = 'rgba(100, 100, 100, 0)'}

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

return config
