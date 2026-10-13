-- ~/.config/hypr/hyprland.lua
-- Docs: https://wiki.hypr.land/Configuring/Start/

---- MY PROGRAMS ----

terminal   = "kitty"
menu       = "rofi -show drun"
fileManager = "dolphin"
browser    = "brave"

---- ENVIRONMENT VARIABLES ----

hl.env("XCURSOR_SIZE", "14")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

---- INPUT ----

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 0,
        sensitivity = 0.3,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            scroll_factor = 0.15
        },
    },
})

-- LAYOUT
hl.config({
    dwindle = { preserve_split = true },
})
hl.config({
    master = { new_status = "master" },
})

-- MISC
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.config({
    xwayland = {
        force_zero_scaling = true, 
        use_nearest_neighbor = true, 
    },
})

---- SPLIT-OUT FILES ----

require("monitors")
require("keybinds")
require("look")
require("rules")
require("autostart")

-- HyprMod managed settings
require("hyprland-gui")
