local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

notifications_widget = wibox.widget.textbox("")
if naughty.is_suspended() then
    notifications_widget.text = " 🔕 "
else
    notifications_widget.text = " 🔔 "
end

notifications_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        if naughty.is_suspended() then
            naughty.resume()
            notifications_widget.text = " 🔔 "
            naughty.notify({
                title = "Naughty",
                text = "Notifications are resumed",
            })
        else
            naughty.suspend()
            notifications_widget.text = " 🔕 "
        end
    end)
))

return notifications_widget
