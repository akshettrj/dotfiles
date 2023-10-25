local wezterm = require("wezterm");

local config = {};

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Appearance
config.font = wezterm.font_with_fallback({
    "JetBrainsMono NF",
    "Lohit Hindi",
})
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.95
config.audible_bell = "Disabled"

return config