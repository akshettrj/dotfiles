local awful = require("awful")
local gears = require("gears")
local vicious = require("vicious")
local wibox = require("wibox")

local ICONS_DIR = os.getenv("HOME") .. "/.config/awesome/akshettrj_widgets/icons/"

local mpd_widget = wibox.widget({
    {
        {
            id = "icon",
            widget = wibox.widget.imagebox
        },
        margins = 2,
        layout = wibox.container.margin,
    },
    {
        id = "txt",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    set_text = function(self, new_value)
        self:get_children_by_id("txt")[1]:set_text(new_value)
    end,
    set_icon = function(self, new_value)
        self:get_children_by_id("icon")[1]:set_image(ICONS_DIR .. new_value)
    end,
})

vicious.register(
    mpd_widget,
    vicious.widgets.mpd,
    function(w, args)
        if args["{state}"] == "Stop" then
            w:set_icon("music_stopped.svg")
            w:set_text(" ")
            return
        elseif args["{state}"] == "Pause" then
            w:set_icon("music_paused.svg")
            w:set_text(" " .. args["{Title}"] .. " ")
            return
        else
            w:set_icon("music_playing.svg")
            w:set_text(
                (" [%s / %s] - %s "):format(
                    args["{Elapsed}"],
                    args["{Duration}"],
                    args["{Title}"]
                ))
            return
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
