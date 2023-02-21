local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local battery_arc_builder = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

local M = {}

M.battery_widget = wibox.container.margin(
    battery_arc_builder({
        font = "JetBrainsMono NF 9",
        arc_thickness = 2,
        show_current_level = true,
        size = 30,
        timeout = 5,
        warning_msg_title = "Huston, we have a problem",
        warning_msg_text = "Battery is dying",
        enable_battery_warning = true,
        show_notification_mode = "on_hover",
    }),
    3, 3, 1, 1
)

M.battery_sep = wibox.widget.separator({
    orientation = "vertical",
    forced_width = 2,
})

M.battery_widget:buttons(gears.table.join(
    awful.button({}, 4, function()
        awful.spawn("brightnessctl --min-value=12000 set '+2%'")
    end),
    awful.button({}, 5, function()
        awful.spawn("brightnessctl --min-value=12000 set '2%-'")
    end)
))

return M
