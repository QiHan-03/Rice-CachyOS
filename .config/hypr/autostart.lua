---- AUTOSTART ----

hl.on("hyprland.start", function()

    -- Allow older apps to display tray icons
    hl.exec_cmd("sleep 3 && xembedsniproxy")

    -- Essentials
    -- hl.exec_cmd("waybar")
    -- hl.exec_cmd("dunst")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")  
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    hl.exec_cmd("sleep 3 && easyeffects --service-mode --hide-window")

    -- Daemons
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper-restore.sh")
    hl.exec_cmd("sleep 3 && QSG_RENDER_LOOP=basic qs")
    
    -- Regular apps
    hl.exec_cmd("brave")
    hl.exec_cmd("discord")
    hl.exec_cmd("steam -silent")
    
    -- Hypyidle
    hl.exec_cmd("hypridle")

    -- System Tray Apps
    hl.exec_cmd("sleep 3 && cachy-update --tray")
end)

---- WINDOW RULES ----

hl.window_rule({
    match = { class = "brave" },
    workspace = "1 silent",
})

hl.window_rule({
    match = { class = "discord" },
    workspace = "2 silent",
})
