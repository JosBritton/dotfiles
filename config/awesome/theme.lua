return {
    font = "sans 8",

    bg_normal = "#222222AA",
    bg_focus = "#333333AA",
    bg_urgent = "#ff0000",
    bg_minimize = "#444444",
    bg_systray = "#222222AA",

    fg_normal = "#ffffff",
    fg_focus = "#ffffff",
    fg_urgent = "#ffffff",
    fg_minimize = "#ffffff",

    border_normal = "#595959aa",
    border_focus = "#33ccffee",
    border_marked = "#91231c",

    border_width = 2,
    useless_gap = 3,
    gap_single_client = true,

    -- master_count = 2,
    -- column_count = 2,

    -- There are other variable sets
    -- overriding the default one when
    -- defined, the sets are:
    -- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
    -- tasklist_[bg|fg]_[focus|urgent]
    -- titlebar_[bg|fg]_[normal|focus]
    -- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
    -- mouse_finder_[color|timeout|animate_timeout|radius|factor]
    -- prompt_[fg|bg|fg_cursor|bg_cursor|font]
    -- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
    -- Example:
    -- taglist_bg_focus = "#ff0000"

    -- Generate taglist squares:
    taglist_squares_sel = require("beautiful.theme_assets").taglist_squares_sel(
        4, "#ffffff"
    ),
    taglist_squares_unsel = require("beautiful.theme_assets").taglist_squares_unsel(
        4, "#ffffff"
    ),

    -- Variables set for theming notifications:
    -- notification_font
    -- notification_[bg|fg]
    -- notification_[width|height|margin]
    -- notification_[border_color|border_width|shape|opacity]

    -- Variables set for theming the menu:
    -- menu_[bg|fg]_[normal|focus]
    -- menu_[border_color|border_width]
    -- menu_submenu_icon = themes_path .. "default/submenu.png",
    menu_height = 15,
    menu_width = 100,

    -- You can add as many variables as
    -- you wish and access them by using
    -- beautiful.variable in your rc.lua
    -- bg_widget = "#cc0000"

    -- Generate Awesome icon:
    -- awesome_icon = theme_assets.awesome_icon(
    --     15, "#333333AA", "#ffffff"
    -- ),

    -- Define the icon theme for application icons. If not set then the icons
    -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
    icon_theme = nil
}
