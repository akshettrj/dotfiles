local wibox = require("wibox")

local volume_builder = require("awesome-wm-widgets.pactl-widget.volume")

local M = {}

M.volume_widget = wibox.container.margin(
    volume_builder({
        mixer_cmd = "pavucontrol",
        step = 2,
        widget_type = "icon_and_text",
        -- device = "pulse",
        with_icon = true,
        margins = 4,
        bg_color = "#ffffff11",
        mute_color = "#ff0000",
    }),
    3, 3, 3, 3
)

M.volume_sep = wibox.widget.separator({
    orientation = "vertical",
    forced_width = 2,
})

return M
