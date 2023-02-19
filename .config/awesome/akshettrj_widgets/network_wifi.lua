local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")

wifi_interface = ""
awful.spawn.with_line_callback("bash -c ~/.scripts/polybar/polybar_wifi_interface", {
    stdout = function(line)
        wifi_interface = line
    end,
    stderr = function(line)
        naughty.notify({
            preset = naughty.config.presets.warn,
            title = "Error while getting wifi interface",
            text = line,
        })
    end,
})

local wifi_widget = wibox.widget.textbox()

vicious.register(
    wifi_widget,
    vicious.widgets.wifiiw,
    function(widget, args)
        return "🗼 " .. args["{ssid}"] .. " (" .. args["{sign}"] .. ")"
    end,
    1,
    wifi_interface
)

return wifi_widget
