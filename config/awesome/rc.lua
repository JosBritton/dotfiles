pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local wallpaper = os.getenv("HOME") .. "/.local/share/wallpapers/surface/websrc/ms_duo_light_hr_web.jpg"

require("awful.hotkeys_popup.keys")

-- fallback config in case of error
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- make sure we don't go into an endless error loop
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

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

awful.mouse.snap.edge_enabled = false

local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor

local modkey = "Mod4"

-- create a launcher widget and a main menu
local myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

local mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

menubar.utils.terminal = terminal -- set the terminal for applications that require it

local datetime = wibox.widget.textclock(
    "%H:%M  %a %Y-%m-%d",
    60
)

-- create a wibox for each screen and add it
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
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    gears.wallpaper.maximized(wallpaper, s, true)
end

-- reset wallpaper when screen resolution changes
screen.connect_signal("property::geometry", set_wallpaper)

local systray = wibox.widget.systray()
local tray = wibox.widget {
    systray,
    valign = "center",
    halign = "center",
    widget = wibox.container.place,
}

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.suit.spiral.dwindle)

    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    s.mytasklist = wibox.container.constraint(awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons
    }, "max", 400)

    s.mywibox = awful.wibar({ position = "top", screen = s })

    systray.base_size = s.mywibox.height - 4

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            -- left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        -- middle widget
        s.mytasklist,
        {
            -- right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 12,
            tray,
            datetime,
        },
    }
end)

-- mouse binds
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- key binds
local globalkeys = gears.table.join(
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, }, "b", function() awful.spawn("chromium") end,
        { description = "open browser", group = "launcher" }),
    awful.key({ modkey, }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ "Control", "Mod1" }, "Del", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ "Control", "Mod1" }, "l", function() awful.spawn("xsecurelock") end,
        { description = "lock system with xsecurelock", group = "awesome" }),
    -- prompt
    awful.key({ modkey }, "Tab", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" })
-- awful.key({ modkey, "Shift" }, "l", function() awful.tag.incmwfact(0.05) end,
--     { description = "increase master width factor", group = "layout" }),
-- awful.key({ modkey, "Shift" }, "h", function() awful.tag.incmwfact(-0.05) end,
--     { description = "decrease master width factor", group = "layout" }),
-- awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
--     { description = "increase the number of master clients", group = "layout" }),
-- awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
--     { description = "decrease the number of master clients", group = "layout" }),
-- awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
--     { description = "increase the number of columns", group = "layout" }),
-- awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
--     { description = "decrease the number of columns", group = "layout" }),
)

local clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, }, "v", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    -- awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
    --     { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),

    -- Moving window focus works between desktops
    awful.key({ modkey, }, "j", function(c)
            c.maximized = false
            awful.client.focus.global_bydirection("down")
            c:lower()
        end,
        { description = "focus next window up", group = "client" }),
    awful.key({ modkey, }, "k", function(c)
            c.maximized = false
            awful.client.focus.global_bydirection("up")
            c:lower()
        end,
        { description = "focus next window down", group = "client" }),
    awful.key({ modkey, }, "l", function(c)
            c.maximized = false
            awful.client.focus.global_bydirection("right")
            c:lower()
        end,
        { description = "focus next window right", group = "client" }),
    awful.key({ modkey, }, "h", function(c)
            c.maximized = false
            awful.client.focus.global_bydirection("left")
            c:lower()
        end,
        { description = "focus next window left", group = "client" }),

    awful.key({ modkey, }, "-",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "+",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    -- layout manipulation
    awful.key({ modkey, "Shift" }, "h", function(c)
        awful.client.swap.global_bydirection("left")
        c:raise()
    end, { description = "swap with client to the left", group = "client" }),
    awful.key({ modkey, "Shift" }, "j", function(c)
        awful.client.swap.global_bydirection("down")
        c:raise()
    end, { description = "swap with client below", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function(c)
        awful.client.swap.global_bydirection("up")
        c:raise()
    end, { description = "swap with client above", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function(c)
        awful.client.swap.global_bydirection("right")
        c:raise()
    end, { description = "swap with client to the right", group = "client" })
)

-- bind all key numbers to tags
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- view tag only
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local s = awful.screen.focused()
                local tag = s.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- toggle tag display
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local s = awful.screen.focused()
                local tag = s.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- move client to tag
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
        -- toggle tag on focused client
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

local clientbuttons = gears.table.join(
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
awful.screen.default_focused_args = { client = true, mouse = false }
root.keys(globalkeys)
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- floating client rules
    {
        rule_any = {
            instance = {
                "DTA",   -- firefox addon downthemall
                "copyq", -- includes session name in class
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Sxiv",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer" },
            name = {
                "Event Tester",
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up",
            }
        },
        properties = {
            floating = true,
            placement = awful.placement.centered
        }
    },

    -- set Thunderbird to always map on the tag named "2" on screen 1.
    {
        rule = { class = "Thunderbird" },
        properties = { screen = 1, tag = "2" }
    },
}

-- signal function to execute when a new client appears.
client.connect_signal("manage", function(c, context)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    elseif c.floating and context == "new" then
        c.placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
    else
        awful.client.setslave(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- c:grant("autoactivate", "history")
-- c:grant("autoactivate", "switch_tag")
-- function module.set(class, request, context, granted)
--                     "client" "autoactivate" "switch_tag", true
--                                             "history"     true

-- makes sure a window is focused
-- e.g., after closing a window, focus other window
require("awful.autofocus")
