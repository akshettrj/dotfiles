pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
require("micky")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
if awesome.hostname == "ltrcakki" then
    beautiful.font = "JetBrainsMono NF 9"
end

awesome.set_preferred_icon_size(32)

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = os.getenv("BROWSER") or "brave"

modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
}
-- }}}

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 400 } }) end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- naughty.notify({
    --     preset = naughty.config.presets.critical,
    --     title = ("Screen number %s"):format(s.index),
    --     text = ("%sx%s+%s+%s"):format(s.workarea.width, s.workarea.height, s.workarea.x, s.workarea.y),
    -- })

    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end))
    )

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    s.mywibox = awful.wibar({ position = "top", screen = s })
    s.mywibox_bottom = awful.wibar({ position = "bottom", screen = s })

    s.mysystray = wibox.widget.systray()
    s.mysystray:set_base_size(20)
    if awesome.hostname == "ltrcakki" then
        s.mysystray = wibox.layout.margin(s.mysystray, 5, 3, 7, 5)
    else
        s.mysystray = wibox.layout.margin(s.mysystray, 3, 0, 3, 0)
    end

    mytextclock = wibox.widget.textclock()
    mytextclock.format = [[ <u>%d/%m/%G, <b>%H:%M:%S (%a)</b></u> ]]
    mytextclock.refresh = 1

    myvolumewidget = require("akshettrj_widgets.volume")
    -- myghactwidget = require("akshettrj_widgets.github_activity")

    right_widgets = {
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.separator({
            orientation = "vertical",
            forced_width = 2,
        }),
        require("akshettrj_widgets.mpd"),
        wibox.widget.separator({
            orientation = "vertical",
            forced_width = 2,
        }),
        require("akshettrj_widgets.notifications_naughty"),
        -- myghactwidget.gh_act_sep,
        -- myghactwidget.gh_act_widget,
        myvolumewidget.volume_sep,
        myvolumewidget.volume_widget,
    }

    if awesome.hostname ~= "ltrcakki" then
        mybatterywidget = require("akshettrj_widgets.battery")
        right_widgets[#right_widgets + 1] = mybatterywidget.battery_sep
        right_widgets[#right_widgets + 1] = mybatterywidget.battery_widget
    end

    right_widgets[#right_widgets + 1] = wibox.widget.separator({
        orientation = "vertical",
        forced_width = 2,
    })
    right_widgets[#right_widgets + 1] = s.mysystray

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            wibox.widget.separator({
                orientation = "vertical",
                forced_width = 2,
            }),
            s.mypromptbox,
        },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.separator({
                orientation = "vertical",
                forced_width = 2,
            }),
            -- mytextclock,
            s.mylayoutbox,
        }
    }

    s.mywibox_bottom:setup({
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.separator({
                orientation = "vertical",
                forced_width = 2,
            }),
            mytextclock,
            wibox.widget.separator({
                orientation = "vertical",
                forced_width = 2,
            }),
        },
        {
            layout = wibox.layout.fixed.horizontal,
        },
        right_widgets,
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ modkey, }, "F4", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    -- Change tags
    awful.key({ modkey, }, "[", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "]", awful.tag.viewnext,
        { description = "view next", group = "tag" }),


    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.bydirection("down") end,
        { description = "swap with client in down direction", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.bydirection("up") end,
        { description = "swap with client in up direction", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.bydirection("left") end,
        { description = "swap with client in left direction", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.bydirection("right") end,
        { description = "swap with client in right direction", group = "layout" }),

    -- Urgent client
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),

    -- Focus screen
    awful.key({ modkey, }, "Tab", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Shift" }, "Tab", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),

    -- Reload / Quit
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Control", "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    -- Number of master windows
    awful.key({ modkey }, "n", function() awful.tag.incnmaster(1) end,
        { description = "increase number of master windows", group = "layout" }),
    awful.key({ modkey, "Shift" }, "n", function() awful.tag.incnmaster(-1) end,
        { description = "decrease number of master columns", group = "layout" }),

    -- unminimize apps
    awful.key({ modkey, "Shift" }, "-",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    awful.key({ modkey }, "r",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),

    awful.key({ modkey, }, "j",
        function(c)
            awful.client.focus.bydirection("down")
            c:lower()
        end,
        { description = "focus next window down", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function(c)
            awful.client.focus.bydirection("up")
            c:lower()
        end,
        { description = "focus next window up", group = "client" }
    ),
    awful.key({ modkey, }, "h",
        function(c)
            awful.client.focus.bydirection("left")
            c:lower()
        end,
        { description = "focus next window left", group = "client" }
    ),
    awful.key({ modkey, }, "l",
        function(c)
            awful.client.focus.bydirection("right")
            c:lower()
        end,
        { description = "focus next window right", group = "client" }
    ),

    awful.key({ modkey, }, "w", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Shift" }, "w", function(c)
        if c.pid then
            awful.spawn("kill -9 " .. c.pid)
        end
    end,
        { description = "force close (kill PID)", group = "client" }),
    awful.key({ modkey, }, "s", function(c)
        awful.client.floating.toggle(c)
    end,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "-",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            if c.maximized then
                c:raise()
            else
                c:lower()
            end
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" }),
    awful.key({ modkey }, "b", function(c)
        c.opacity = math.min(c.opacity + 0.1, 1)
    end,
        { description = "increase background opacity", group = "client" }),
    awful.key({ modkey, "Shift" }, "b", function(c)
        c.opacity = math.max(c.opacity - 0.1, 0)
    end,
        { description = "decrease background opacity", group = "client" }),
    awful.key({ modkey, "Control" }, "s", function(c)
        c.sticky = not c.sticky
    end,
        { description = "make client (un)sticky", group = "client" }),

    -- Resizing and moving
    awful.key({ modkey, "Control" }, "Up", function(c)
        if c.floating then
            c:relative_move(0, 0, 0, -10)
        else
            awful.client.incwfact(0.025)
        end
    end, { description = "floating resize vertical -", group = "client" }),
    awful.key({ modkey, "Control" }, "Down", function(c)
        if c.floating then
            c:relative_move(0, 0, 0, 10)
        else
            awful.client.incwfact(-0.025)
        end
    end, { description = "floating resize vertical +", group = "client" }),
    awful.key({ modkey, "Control" }, "Left", function(c)
        if c.floating then
            c:relative_move(0, 0, -10, 0)
        else
            awful.tag.incmwfact(-0.025)
        end
    end, { description = "floating resize horizontal -", group = "client" }),
    awful.key({ modkey, "Control" }, "Right", function(c)
        if c.floating then
            c:relative_move(0, 0, 10, 0)
        else
            awful.tag.incmwfact(0.025)
        end
    end, { description = "floating resize horizontal +", group = "client" }),

    -- Moving floating windows
    awful.key({ modkey, }, "Down", function(c)
        c:relative_move(0, 10, 0, 0)
    end,
        { description = "Floating Move Down", group = "client" }),
    awful.key({ modkey, }, "Up", function(c)
        c:relative_move(0, -10, 0, 0)
    end,
        { description = "Floating Move Up", group = "client" }),
    awful.key({ modkey, }, "Left", function(c)
        c:relative_move(-10, 0, 0, 0)
    end,
        { description = "Floating Move Left", group = "client" }),
    awful.key({ modkey, }, "Right", function(c)
        c:relative_move(10, 0, 0, 0)
    end,
        { description = "Floating Move Right", group = "client" })

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            opacity = 1,
            size_hints_honor = false,
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "copyq", -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Sxiv",
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            -- "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true, raise = true } },

    { rule_any = { type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false, requests_no_titlebar = false }
    },

    { rule = { class = "mpv" },
        properties = { screen = awful.screen.preferred, fullscreen = true, }
    },

    { rule = { class = "Alacritty" },
        properties = { opacity = 0.9 }
    },

    { rule = { class = "64Gram" },
        properties = { screen = awful.screen.preferred }
    },

    { rule = { class = "discord" },
        properties = { screen = awful.screen.preferred }
    },

    { rule = { class = "Dragon-drop" },
        properties = { screen = awful.screen.preferred, floating = true, sticky = true, ontop = true, }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", { raise = false })
-- end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus

    myscreen = awful.screen.focused()
    if not c.fullscreen and not c.maximized then
        for _, _c in ipairs(myscreen.clients) do
            _c.fullscreen = false
            _c.maximized = false
        end
    end
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    myscreen = awful.screen.focused()
end)

client.connect_signal("property::floating", function(c)
    if c.floating and not c.fullscreen then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
    c.ontop = c.floating and not c.fullscreen
end)

client.connect_signal("property::maximized", function(c)
    if c.maximized then
        c.floating = false
    end
end)
-- }}}

-- Autostart Applications
awful.spawn.with_shell("~/.config/startup.sh " .. awesome.hostname)
