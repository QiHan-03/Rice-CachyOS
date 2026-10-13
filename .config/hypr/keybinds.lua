-- ~/.config/hypr/keybinds.lua
-- Migrated from keybinds.conf
-- Docs: https://wiki.hypr.land/Configuring/Basics/Binds/
--       https://wiki.hypr.land/Configuring/Basics/Dispatchers/

require("functions")

mainMod    = "SUPER"

local home = os.getenv("HOME")
local menu = "rofi -show drun"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal)) -- Terminal (
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pgrep -x rofi >/dev/null && pkill -x rofi || " .. menu)) -- App launcher
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager)) -- File manager
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser)) -- Browser
hl.bind(mainMod .. " + W", hl.dsp.window.close()) -- Close window

hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprlock")) -- Lock screen
hl.bind(mainMod .. " + GRAVE", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/wlogout.sh")) -- Power menu

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 })) -- Fullscreen

hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("qs ipc call settings toggle")) -- Quick settings
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/opacity.sh")) -- Window opacity
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("qs -n -p ~/.config/quickshell/hyprquickpaper")) -- Wallpaper picker

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Move window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize window

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("sh -c 'pgrep -x waybar >/dev/null && pkill waybar || nohup waybar >/dev/null 2>&1 &'")) -- Toggle waybar

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pgrep -x rofi >/dev/null && pkill -x rofi || cliphist list | rofi -dmenu -p '' | cliphist decode | wl-copy")) -- Clipboard


-- Screenshot
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd("grim - | swappy -f -")) -- Screenshot (fullscreen)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -')) -- Select

-- Screen Recordings
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.local/bin/record-region-toggle")) -- Screen record (toggle)


-- Toggle float window, center and rezise
hl.bind(mainMod .. " + Space", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))

    local w = hl.get_active_window()
    if w ~= nil and w.floating then
        local mon = hl.get_active_monitor()
        if mon ~= nil then
            local target_w = math.floor(mon.width * 0.7) 
            local target_h = math.floor(mon.height * 0.7)

            -- absolute resize (relative = false), not a delta
            hl.dispatch(hl.dsp.window.resize({ x = target_w, y = target_h, relative = false }))

            local mon_x = mon.x or 0
            local mon_y = mon.y or 0
            local target_x = mon_x + math.floor((mon.width - target_w) / 2)
            local target_y = mon_y + math.floor((mon.height - target_h) / 2)

            -- absolute move to the centered position
            hl.dispatch(hl.dsp.window.move({ x = target_x, y = target_y, relative = false }))
        end
    end
end)


-- -- Zoom
-- local function zoomfunction(value)
--     local zoomvalue = hl.get_config("cursor:zoom_factor")
--     if (zoomvalue + value) > 1.5 then
--         hl.config({ cursor = { zoom_factor = 1.5 } })
--     elseif (zoomvalue + value) < 1.0 then
--         hl.config({ cursor = { zoom_factor = 1.0 } })
--     else
--         hl.config({ cursor = { zoom_factor = zoomvalue + value } })
--     end
-- end
-- hl.bind(mainMod .. " + mouse_down", function() zoomfunction(-0.5) end, { repeating = true })
-- hl.bind(mainMod .. " + mouse_up", function() zoomfunction(0.5) end, { repeating = true })


-- Focus (H/J/K/L = left/down/up/right, vim-style, matching your original)
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))

-- VERIFY: move active window within layout (old `movewindow` dispatcher).
-- Confirmed pattern is hl.dsp.window.move({ workspace = N }) for sending to a
-- workspace (used below) - the direction-swap variant isn't shown in the
-- official example, so double check this fires like the old movewindow did.
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))


-- Workspaces 1-10, and move-to-workspace with SHIFT (confirmed pattern from
-- the official example config)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end


-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Media keys (confirmed pattern from the official example config)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- Toggle laptop monitor
hl.bind(mainMod .. " + SHIFT + M", toggleLaptopMonitor)