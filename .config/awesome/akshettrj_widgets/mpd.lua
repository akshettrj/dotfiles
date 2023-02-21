local awful = require("awful")
local gears = require("gears")
local vicious = require("vicious")
local wibox = require("wibox")

local mpd_widget = wibox.widget.textbox()

vicious.register(
    mpd_widget,
    vicious.widgets.mpd,
    function(_, args)
        if args["{state}"] == "Stop" then
            return " 🎶 stopped "
        elseif args["{state}"] == "Pause" then
            return " 🎶 paused "
        else
            return (" 🎶 %s / %s "):format(args["{Elapsed}"], args["{Duration}"])
        end
    end,
    1,
    { nil, nil, nil }
)

mpd_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        vicious.widgets.mpd.previous()
    end),
    awful.button({}, 2, function()
        vicious.widgets.mpd.playpause()
    end),
    awful.button({}, 3, function()
        vicious.widgets.mpd.next()
    end)
))

return mpd_widget
