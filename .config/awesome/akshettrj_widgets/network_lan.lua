local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")

lan_interface = ""
awful.spawn.with_line_callback("bash -c ~/.scripts/polybar/polybar_lan_interface", {
    stdout = function(line)
        wifi_interface = line
    end,
    stderr = function(line)
        naughty.notify({
            preset = naughty.config.presets.warn,
            title = "Error while getting lan interface",
            text = line,
        })
    end,
})

local lan_widget = wibox.widget.textbox()

vicious.register(
    lan_widget,
    vicious.widgets.net,
    function(widget, args)
        if args == nil then
            widget.visible = false
            return ""
        else
            widget.visible = true
        end
        return ""
    end,
    1,
    { wifi_interface }
)

return lan_widget
