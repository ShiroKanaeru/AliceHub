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

-- ================== BUAT GUI (ARSITEKTUR BARU ANTI BUG) ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "aliceHUB"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Utama (Background)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 460)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

-- Scroller utama (Supaya semua menu bisa digeser ke bawah)
local mainScroller = Instance.new("ScrollingFrame")
mainScroller.Size = UDim2.new(1, 0, 1, 0)
mainScroller.BackgroundTransparency = 1
mainScroller.BorderSizePixel = 0
mainScroller.ScrollBarThickness = 4
mainScroller.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 255)
mainScroller.Parent = mainFrame

-- Wadah Konten (Memakai AutomaticSize, inti dari perbaikan biar gak ilang)
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 0, 0)
container.Position = UDim2.new(0, 10, 0, 0)
container.BackgroundTransparency = 1
container.AutomaticSize = Enum.AutomaticSize.Y
container.Parent = mainScroller

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

-- ================== HEADER ==================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundTransparency = 1
header.LayoutOrder = 0
header.Parent = container

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 0.6, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "✦ aliceHUB ✦"
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.7, 0, 0.4, 0)
subtitle.Position = UDim2.new(0, 0, 0.6, 0)
subtitle.Text = "Auto Farm Controller"
subtitle.TextColor3 = Color3.fromRGB(160, 160, 200)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.BackgroundTransparency = 1
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Tombol Minimize (_)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 22)
minBtn.Position = UDim2.new(1, -56, 0.5, -11)
minBtn.Text = "_"
minBtn.TextSize = 14
minBtn.TextColor3 = Color3.fromRGB(200, 200, 230)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minBtn.BorderSizePixel = 0
minBtn.Font = Enum.Font.GothamBold
minBtn.AutoButtonColor = false
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn
minBtn.Parent = header

-- Tombol Close (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.Text = "✕"
closeBtn.TextSize = 12
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn
closeBtn.Parent = header

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.LayoutOrder = 1
divider.Parent = container

-- ================== FUNGSI SWITCH & DROPDOWN (FIXED) ==================
local function createSwitch(labelText, order, onToggle)
    local containerItem = Instance.new("Frame")
    containerItem.Size = UDim2.new(1, 0, 0, 34)
    containerItem.BackgroundTransparency = 1
    containerItem.LayoutOrder = order
    containerItem.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = containerItem

    local switchBtn = Instance.new("ImageButton")
    switchBtn.Size = UDim2.new(0, 40, 0, 22)
    switchBtn.Position = UDim2.new(1, -40, 0.5, -11)
    switchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    switchBtn.BackgroundTransparency = 0.3
    switchBtn.BorderSizePixel = 0
    switchBtn.Image = "rbxassetid://3570695787"
    switchBtn.ScaleType = Enum.ScaleType.Slice
    switchBtn.SliceCenter = Rect.new(4, 4, 12, 12)
    switchBtn.Parent = containerItem

    local knob = Instance.new("ImageLabel")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.Parent = switchBtn

    local state = false
    local function updateSwitch(newState)
        state = newState
        if state then
            switchBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
            knob.Position = UDim2.new(1, -19, 0.5, -8)
        else
            switchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            knob.Position = UDim2.new(0, 3, 0.5, -8)
        end
        if onToggle then onToggle(state) end
    end
    switchBtn.MouseButton1Click:Connect(function() updateSwitch(not state) end)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.2, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.8, -5, 0, 0)
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Parent = containerItem

    local oldToggle = onToggle
    local function newOnToggle(newState)
        statusLabel.Text = newState and "ON" or "OFF"
        statusLabel.TextColor3 = newState and Color3.fromRGB(80, 220, 100) or Color3.fromRGB(150, 150, 180)
        if oldToggle then oldToggle(newState) end
    end
    return {
        setState = function(s) updateSwitch(s) end,
        getState = function() return state end,
        toggle = function() updateSwitch(not state) end,
    }
end

local function createDropdown(labelText, options, order, onSelect)
    local containerItem = Instance.new("Frame")
    containerItem.Size = UDim2.new(1, 0, 0, 34)
    containerItem.BackgroundTransparency = 1
    containerItem.LayoutOrder = order
    containerItem.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.35, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = containerItem

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.6, 0, 0.75, 0)
    dropdownBtn.Position = UDim2.new(0.35, 0, 0.125, 0)
    dropdownBtn.Text = "▼ " .. options[1]
    dropdownBtn.TextSize = 10
    dropdownBtn.Font = Enum.Font.GothamSemibold
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = containerItem
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 5)
    dc.Parent = dropdownBtn

    -- FIX: List Frame dengan CanvasSize Manual biar itemnya muncul
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(0.6, 0, 0, 0)
    listFrame.Position = UDim2.new(0.35, 0, 0.9, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.ScrollBarThickness = 3
    listFrame.ZIndex = 5
    listFrame.Parent = containerItem
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 5)
    lc.Parent = listFrame
    
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
            local bcorner = Instance.new("UICorner")
            bcorner.CornerRadius = UDim.new(0, 3)
            bcorner.Parent = btn
            btn.MouseButton1Click:Connect(function()
                selected = opt
                dropdownBtn.Text = "▼ " .. opt
                listFrame.Size = UDim2.new(0.6, 0, 0, 0)
                if onSelect then onSelect(opt) end
            end)
            totalHeight = totalHeight + 26
        end
        -- KUNCI UTAMA: Ini bikin item yang ada di scrollbarnya jadi kelihatan
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    rebuildList()

    local isOpen = false
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local maxHeight = 130
            local totalListHeight = #options * 26 + 6
            listFrame.Size = UDim2.new(0.6, 0, 0, math.min(totalListHeight, maxHeight))
            -- Memastikan CanvasSize tetap aman
            listFrame.CanvasSize = UDim2.new(0, 0, 0, totalListHeight)
        else
            listFrame.Size = UDim2.new(0.6, 0, 0, 0)
        end
    end)

    return { getSelected = function() return selected end }
end

-- ================== STATE & THREADS ==================
local states = { throw = false, buy = false, sell = false, luck = false, value = false, afk = false }
local threads = {}
local isMinimized = false

-- ================== BUAT FITUR ==================
local orderIdx = 2 

-- 1. Auto Throw
local throwDropdown = createDropdown("Throw Coin", coinList, orderIdx, function(opt) throwParams[3] = opt end)
orderIdx = orderIdx + 1
local throwSwitch = createSwitch("Auto Throw", orderIdx, function(state)
    states.throw = state
    if state then
        threads.throw = task.spawn(function()
            while states.throw do
                events.throw:FireServer(unpack(throwParams))
                task.wait(0.5)
            end
        end)
    elseif threads.throw then task.cancel(threads.throw); threads.throw = nil end
end)
orderIdx = orderIdx + 1

-- 2. Auto Buy
local buyDropdown = createDropdown("Buy Coin", coinList, orderIdx)
orderIdx = orderIdx + 1
local buySwitch = createSwitch("Auto Buy", orderIdx, function(state)
    states.buy = state
    if state then
        threads.buy = task.spawn(function()
            while states.buy do
                events.buy:FireServer(buyDropdown.getSelected())
                task.wait(0.5)
            end
        end)
    elseif threads.buy then task.cancel(threads.buy); threads.buy = nil end
end)
orderIdx = orderIdx + 1

-- 3. Auto Sell All
local sellSwitch = createSwitch("Auto Sell All", orderIdx, function(state)
    states.sell = state
    if state then
        threads.sell = task.spawn(function()
            while states.sell do
                events.sell:FireServer()
                task.wait(0.5)
            end
        end)
    elseif threads.sell then task.cancel(threads.sell); threads.sell = nil end
end)
orderIdx = orderIdx + 1

-- 4. Upgrade Luck
local luckSwitch = createSwitch("Upgrade Luck", orderIdx, function(state)
    states.luck = state
    if state then
        threads.luck = task.spawn(function()
            while states.luck do
                events.upgrade:FireServer("Luck Multiplier")
                task.wait(0.5)
            end
        end)
    elseif threads.luck then task.cancel(threads.luck); threads.luck = nil end
end)
orderIdx = orderIdx + 1

-- 5. Upgrade Value
local valueSwitch = createSwitch("Upgrade Value (Cash)", orderIdx, function(state)
    states.value = state
    if state then
        threads.value = task.spawn(function()
            while states.value do
                events.upgrade:FireServer("Value Multiplier")
                task.wait(0.5)
            end
        end)
    elseif threads.value then task.cancel(threads.value); threads.value = nil end
end)
orderIdx = orderIdx + 1

-- 6. AFK Safe
local afkSwitch = createSwitch("AFK Safe", orderIdx, function(state)
    states.afk = state
    events.afk:FireServer(state)
end)
orderIdx = orderIdx + 1

-- ================== FUNGSI MINIMIZE & CLOSE ==================
local function minimizeGUI()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 340, 0, 70)
        mainFrame.Position = UDim2.new(0.5, -170, 0.8, -35)
        minBtn.Text = "+"
        container.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 340, 0, 460)
        mainFrame.Position = UDim2.new(0.5, -170, 0.5, -230)
        minBtn.Text = "_"
        container.Visible = true
    end
end

local function closeGUI()
    for _, name in ipairs({"throw","buy","sell","luck","value"}) do
        if threads[name] then task.cancel(threads[name]) end
    end
    screenGui:Destroy()
end

minBtn.MouseButton1Click:Connect(minimizeGUI)
closeBtn.MouseButton1Click:Connect(closeGUI)

screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        for _, name in ipairs({"throw","buy","sell","luck","value"}) do
            if threads[name] then task.cancel(threads[name]) end
        end
    end
end)

player.CharacterAdded:Connect(function()
    for _, sw in ipairs({throwSwitch, buySwitch, sellSwitch, luckSwitch, valueSwitch}) do
        if sw.getState() then sw.toggle() end
    end
end)

print("✨ AliceHUB (Final Fix! Anti drop-down kosong) siap digunakan!")
