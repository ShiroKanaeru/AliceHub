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

-- ================== BUAT GUI (LAYOUT KOMPAK 2 KOLOM) ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "aliceHUB"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Utama (Ukuran dibikin 340x320 agar kompak seperti video)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 320)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

-- ================== HEADER ==================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -20, 0, 45)
header.Position = UDim2.new(0, 10, 0, 0)
header.BackgroundTransparency = 1
header.Parent = mainFrame

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
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 45)
divider.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- ================== KONTEN UTAMA (TANPA SCROLL PANJANG) ==================
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 0, 250)
contentContainer.Position = UDim2.new(0, 10, 0, 50)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentContainer

-- ================== FUNGSI SWITCH & DROPDOWN ==================
local function createSwitch(labelText, order, onToggle)
    local containerItem = Instance.new("Frame")
    containerItem.Size = UDim2.new(0.5, -3, 0, 34) -- Setengah lebar (biar 2 kolom)
    containerItem.BackgroundTransparency = 1
    containerItem.LayoutOrder = order
    containerItem.Parent = contentContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = containerItem

    local switchBtn = Instance.new("ImageButton")
    switchBtn.Size = UDim2.new(0, 36, 0, 20)
    switchBtn.Position = UDim2.new(1, -36, 0.5, -10)
    switchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    switchBtn.BackgroundTransparency = 0.3
    switchBtn.BorderSizePixel = 0
    switchBtn.Image = "rbxassetid://3570695787"
    switchBtn.ScaleType = Enum.ScaleType.Slice
    switchBtn.SliceCenter = Rect.new(4, 4, 12, 12)
    switchBtn.Parent = containerItem

    local knob = Instance.new("ImageLabel")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.Parent = switchBtn

    local state = false
    local function updateSwitch(newState)
        state = newState
        if state then
            switchBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
            knob.Position = UDim2.new(1, -17, 0.5, -7)
        else
            switchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            knob.Position = UDim2.new(0, 3, 0.5, -7)
        end
        if onToggle then onToggle(state) end
    end
    switchBtn.MouseButton1Click:Connect(function() updateSwitch(not state) end)

    return {
        setState = function(s) updateSwitch(s) end,
        getState = function() return state end,
        toggle = function() updateSwitch(not state) end,
    }
end

local function createDropdown(labelText, options, order, onSelect)
    local containerItem = Instance.new("Frame")
    containerItem.Size = UDim2.new(1, 0, 0, 34) -- Dropdown full lebar (biar teks muat)
    containerItem.BackgroundTransparency = 1
    containerItem.LayoutOrder = order
    containerItem.Parent = contentContainer

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

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(0.6, 0, 0, 0)
    listFrame.Position = UDim2.new(0.35, 0, 0.9, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.ScrollBarThickness = 3
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
        end
    end
    rebuildList()

    local isOpen = false
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local maxHeight = 120
            listFrame.Size = UDim2.new(0.6, 0, 0, math.min(#options * 26 + 6, maxHeight))
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
local orderIdx = 0

-- DROPDOWN (Ditaruh di bagian atas)
local throwDropdown = createDropdown("Throw Coin", coinList, orderIdx, function(opt) throwParams[3] = opt end)
orderIdx = orderIdx + 1
local buyDropdown = createDropdown("Buy Coin", coinList, orderIdx)
orderIdx = orderIdx + 1

-- SWITCH (Menggunakan ukuran 0.5 agar menjadi 2 kolom)
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

local valueSwitch = createSwitch("Upgrade Value", orderIdx, function(state)
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
        contentContainer.Visible = false
        divider.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 340, 0, 320)
        mainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
        minBtn.Text = "_"
        contentContainer.Visible = true
        divider.Visible = true
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

print("✨ AliceHUB Layout 2 Kolom (Kompak!) siap dipakai!")
