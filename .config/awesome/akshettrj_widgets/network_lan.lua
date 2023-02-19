local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")

lan_interface = ""
awful.spawn.with_line_callback("bash -c ~/.scripts/polybar/polybar_lan_interface", {
    stdout = function(line)
        lan_interface = line
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

function get_property(array, property)
    return array["{" .. lan_interface .. " " .. property .. "}"]
end

vicious.register(
    lan_widget,
    vicious.widgets.net,
    function(widget, args)
        text = "🧵 "

        local up_speed_b = tonumber(get_property(args, "up_b")) or 0
        local up_speed_kb = tonumber(get_property(args, "up_kb")) or 0
        local up_speed_mb = tonumber(get_property(args, "up_mb")) or 0
        local up_speed_gb = tonumber(get_property(args, "up_gb")) or 0

        if up_speed_gb > 1 then
            text = text .. up_speed_gb .. "gbps"
        elseif up_speed_mb > 1 then
            text = text .. up_speed_mb .. "mbps"
        elseif up_speed_kb > 1 then
            text = text .. up_speed_kb .. "kbps"
        else
            text = text .. up_speed_b .. "bps"
        end
        text = text .. " (U) "

        local down_speed_b = tonumber(get_property(args, "down_b")) or 0
        local down_speed_kb = tonumber(get_property(args, "down_kb")) or 0
        local down_speed_mb = tonumber(get_property(args, "down_mb")) or 0
        local down_speed_gb = tonumber(get_property(args, "down_gb")) or 0

        if down_speed_gb > 1 then
            text = text .. down_speed_gb .. "gbps"
        elseif down_speed_mb > 1 then
            text = text .. down_speed_mb .. "mbps"
        elseif down_speed_kb > 1 then
            text = text .. down_speed_kb .. "kbps"
        else
            text = text .. down_speed_b .. "bps"
        end
        text = text .. " (D)"

        return text
    end,
    2
)

return lan_widget
