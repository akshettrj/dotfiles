local awful = require("awful")
local gears = require("gears")
local vicious = require("vicious")

local pa_volume_widget = awful.widget.watch("bash -c ~/.scripts/polybar/polybar_volume", 15, function(widget, stdout)
    for line in stdout:gmatch("[^\r\n]+") do
        if line:match("temp1") then
            widget:set_text(line)
            return
        end
    end
end)

return pa_volume_widget
