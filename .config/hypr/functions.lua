function toggleLaptopMonitor()
    -- Can only toggle if external monitor is active
    if hl.get_monitor("DP-1") == nil then
        return
    end

    if hl.get_monitor("eDP-1") ~= nil then
        disableLaptopMonitor()
    else
        enableLaptopMonitor()
    end
end

function enableLaptopMonitor()
    hl.monitor({
        output = "eDP-1",
        mode = "2560x1440@165",
        position = "auto-left",
        scale = 1.25,
        disabled = false
    })
end

function disableLaptopMonitor()
    hl.monitor({
        output = "eDP-1",
        disabled = true
    })
end