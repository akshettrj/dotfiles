local wezterm = require("wezterm");

local config = {};

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Appearance
config.font = wezterm.font("JetBrainsMono NF")
config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9

return config
