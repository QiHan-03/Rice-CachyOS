require("functions")

-- To check names run: hyprctl monitors 

-- 1. First monitor
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", disabled = true })

-- 2. Second monitor
-- hl.monitor({ output = "eDP-1", disabled = true })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })

-- 3. Extend/Auto
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@165",
    position = "0x0",
    scale = 1
})

hl.monitor({
    output = "eDP-1",
    mode = "2560x1440@165",
    position = "auto-right",
    scale = 1.25,
    -- disabled = true  --for when editing config, saving files reloads hyprctl
})

hl.on("monitor.removed", function(monitor)
    if monitor.name == "DP-1" then
        enableLaptopMonitor()
    end
end)

-- 4. Duplicate
--hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })
--hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1 })
