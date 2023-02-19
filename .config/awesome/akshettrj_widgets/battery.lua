local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")

local M = {}
M.battery_widget = awful.widget.watch("bash -c ~/.scripts/polybar/polybar_battery")
M.battery_sep = wibox.widget.textbox("|")

awful.spawn.with_line_callback("bash -c acpi", {
    stdout = function(_)
        M.battery_widget.visible = true
        M.battery_sep.visible = true
    end,
    stderr = function(line)
        if line == "No support for device type: power_supply" then
            M.battery_widget.visible = false
            M.battery_sep.visible = false
        else
            naughty.notify({
                preset = naughty.config.presets.warn,
                title = "Error while getting battery info",
                text = line,
            })
        end
    end,
})

return M
