local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- ================== DAFTAR COIN ==================
local coinList = {
    "Basic Coin", "Copper Coin", "Fortune Coin", "Fire Coin", "Volt Coin",
    "Aether Coin", "Starlight Coin", "Galaxy Coin", "Void Coin", "Chronos Coin",
    "Eclipse Coin", "Mirage Coin", "Obsidian Coin", "Tempest Coin", "Soul Coin",
    "Paradox Coin", "Miracle Coin", "Nexus Coin", "Apex Coin", "Infinity Coin",
    "Grace Coin", "Dominion Coin", "Empyrean Coin", "Atlas Coin", "Judgement Coin",
    "Hercules Coin", "Helios Coin", "Nyx Coin", "Titan Coin", "Zeus Coin",
    "Runic Coin", "Amethyst Coin", "Merlin Coin", "Eldritch Coin", "Avalon Coin",
    "Dragonheart Coin", "Phoenix Coin",
}

-- ================== REMOTE EVENTS ==================
local events = {
    throw = replicatedStorage.Assets.Events.CoinLanded,
    buy = replicatedStorage.Assets.Events.BuyCoin,
    sell = replicatedStorage.Assets.Events.SellAll,
    upgrade = replicatedStorage.Assets.Events.RequestUpgrade,
    afk = replicatedStorage.Assets.Events.SetAFKSafe,
}

local throwParams = {
    1.4278748995675,
    Vector3.new(-1158.4721679688, 0.72600001096725, -176.51705932617),
    coinList[1],
    nil,
    nil,
    5
}

-- ================== BUAT GUI MURNI (ANTI CRASH HP) ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AliceHUBCustom"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 270)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Scroller dalam (Anti terpotong)
local mainScroller = Instance.new("ScrollingFrame")
mainScroller.Size = UDim2.new(1, 0, 1, 0)
mainScroller.BackgroundTransparency = 1
mainScroller.BorderSizePixel = 0
mainScroller.ScrollBarThickness = 3
mainScroller.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 180)
mainScroller.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = mainScroller

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = mainScroller

-- ================== HEADER ==================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundTransparency = 1
header.LayoutOrder = 0
header.Parent = mainScroller

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 0.6, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "✦ aliceHUB ✦"
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.7, 0, 0.4, 0)
subtitle.Position = UDim2.new(0, 0, 0.6, 0)
subtitle.Text = "Auto Farm Controller"
subtitle.TextColor3 = Color3.fromRGB(140, 140, 180)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.BackgroundTransparency = 1
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
closeBtn.Text = "✕"
closeBtn.TextSize = 12
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(0, 6); cCorner.Parent = closeBtn

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.LayoutOrder = 1
divider.Parent = mainScroller

-- ================== DROPDOWN LIST ==================
local function createDropdown(labelText, options, order, onSelect)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = mainScroller

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.65, 0, 0.75, 0)
    dropdownBtn.Position = UDim2.new(0.3, 0, 0.125, 0)
    dropdownBtn.Text = "▼ " .. options[1]
    dropdownBtn.TextSize = 10
    dropdownBtn.Font = Enum.Font.GothamSemibold
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = container
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0, 5); dc.Parent = dropdownBtn

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(0.65, 0, 0, 0)
    listFrame.Position = UDim2.new(0.3, 0, 0.9, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.ScrollBarThickness = 3
    listFrame.Parent = container
    local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0, 5); lc.Parent = listFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local selected = options[1]
    local function rebuildList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local totalHeight = 0
        for _, opt in ipairs(options) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 24)
            btn.Text = opt
            btn.TextSize = 10
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.fromRGB(220, 220, 255)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            btn.BorderSizePixel = 0
            btn.Parent = listFrame
            local bcorner = Instance.new("UICorner"); bcorner.CornerRadius = UDim.new(0, 3); bcorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                selected = opt
                dropdownBtn.Text = "▼ " .. opt
                listFrame.Size = UDim2.new(0.65, 0, 0, 0)
                if onSelect then onSelect(opt) end
            end)
            totalHeight = totalHeight + 26
        end
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    rebuildList()

    local isOpen = false
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local total = #options * 26 + 6
            listFrame.Size = UDim2.new(0.65, 0, 0, math.min(total, 120))
        else
            listFrame.Size = UDim2.new(0.65, 0, 0, 0)
        end
    end)

    return { getSelected = function() return selected end }
end

-- ================== TOMBOL SWITCH 2 KOLOM ==================
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Size = UDim2.new(1, 0, 0, 0)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.AutomaticSize = Enum.AutomaticSize.Y
buttonsContainer.LayoutOrder = 4
buttonsContainer.Parent = mainScroller

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.5, -3, 0, 32)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = buttonsContainer

local function createSwitch(labelText, order, onToggle)
    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(1, 0, 0, 0)
    sw.BackgroundTransparency = 1
    sw.LayoutOrder = order
    sw.Parent = buttonsContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sw

    local switchBtn = Instance.new("ImageButton")
    switchBtn.Size = UDim2.new(0, 34, 0, 18)
    switchBtn.Position = UDim2.new(1, -34, 0.5, -9)
    switchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    switchBtn.BackgroundTransparency = 0.3
    switchBtn.BorderSizePixel = 0
    switchBtn.Image = "rbxassetid://3570695787"
    switchBtn.ScaleType = Enum.ScaleType.Slice
    switchBtn.SliceCenter = Rect.new(4, 4, 12, 12)
    switchBtn.Parent = sw

    local knob = Instance.new("ImageLabel")
    knob.Size = UDim2.new(0, 13, 0, 13)
    knob.Position = UDim2.new(0, 2, 0.5, -6.5)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.Parent = switchBtn

    local state = false
    switchBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            switchBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
            knob.Position = UDim2.new(1, -15, 0.5, -6.5)
        else
            switchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            knob.Position = UDim2.new(0, 2, 0.5, -6.5)
        end
        if onToggle then onToggle(state) end
    end)

    return { getState = function() return state end }
end

-- ================== STATE ==================
local threads = {}
local isMinimized = false

-- ================== MENU UTAMA ==================
local orderIdx = 2

local throwDropdown = createDropdown("Throw Coin", coinList, orderIdx, function(opt) throwParams[3] = opt end)
orderIdx = orderIdx + 1
local buyDropdown = createDropdown("Buy Coin", coinList, orderIdx)
orderIdx = orderIdx + 1

local throwSwitch = createSwitch("Auto Throw", orderIdx, function(s)
    if s then
        threads.throw = task.spawn(function()
            while true do
                events.throw:FireServer(unpack(throwParams))
                task.wait(0.4)
            end
        end)
    else
        if threads.throw then task.cancel(threads.throw); threads.throw = nil end
    end
end)
orderIdx = orderIdx + 1

local buySwitch = createSwitch("Auto Buy", orderIdx, function(s)
    if s then
        threads.buy = task.spawn(function()
            while true do
                events.buy:FireServer(buyDropdown.getSelected())
                task.wait(0.4)
            end
        end)
    else
        if threads.buy then task.cancel(threads.buy); threads.buy = nil end
    end
end)
orderIdx = orderIdx + 1

local sellSwitch = createSwitch("Auto Sell", orderIdx, function(s)
    if s then
        threads.sell = task.spawn(function()
            while true do
                events.sell:FireServer()
                task.wait(0.4)
            end
        end)
    else
        if threads.sell then task.cancel(threads.sell); threads.sell = nil end
    end
end)
orderIdx = orderIdx + 1

local luckSwitch = createSwitch("Luck Upgrade", orderIdx, function(s)
    if s then
        threads.luck = task.spawn(function()
            while true do
                events.upgrade:FireServer("Luck Multiplier")
                task.wait(0.4)
            end
        end)
    else
        if threads.luck then task.cancel(threads.luck); threads.luck = nil end
    end
end)
orderIdx = orderIdx + 1

local valueSwitch = createSwitch("Value Upgrade", orderIdx, function(s)
    if s then
        threads.value = task.spawn(function()
            while true do
                events.upgrade:FireServer("Value Multiplier")
                task.wait(0.4)
            end
        end)
    else
        if threads.value then task.cancel(threads.value); threads.value = nil end
    end
end)
orderIdx = orderIdx + 1

local afkSwitch = createSwitch("AFK Safe", orderIdx, function(s)
    events.afk:FireServer(s)
end)

-- ================== FUNGSI CLOSE ==================
closeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(threads) do if t then task.cancel(t) end end
    screenGui:Destroy()
end)

print("✅ AliceHUB (Versi Murni 2 Kolom) berhasil dimuat! Gas main!")
