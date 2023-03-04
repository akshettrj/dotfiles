local wibox = require("wibox")

local github_activity_widget = require("awesome-wm-widgets.github-activity-widget.github-activity-widget")

local M = {}

M.gh_act_widget = wibox.container.margin(
    github_activity_widget({
        username = "akshettrj",
    }),
    3, 3, 1, 1
)

M.gh_act_sep = wibox.widget.separator({
    orientation = "vertical",
    forced_width = 2,
})

return M
