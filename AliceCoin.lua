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

local threads = {}
local state = { throw = false, buy = false, sell = false, luck = false, value = false, afk = false }

-- ================== STRUKTUR GUI ==================
local gui = Instance.new('ScreenGui')
gui.Name = 'AliceHUBSplit'
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild('PlayerGui')

-- Frame Utama
local panel = Instance.new('ScrollingFrame')
panel.Size = UDim2.fromOffset(340, 400)
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.new(0.5, 0, 1, -15)
panel.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
panel.BorderSizePixel = 0
panel.ScrollBarThickness = 4
panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
panel.Active = true
panel.Draggable = true
panel.Parent = gui

local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local padding = Instance.new('UIPadding')
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = panel

local list = Instance.new('UIListLayout')
list.Padding = UDim.new(0, 8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = panel

-- ================== HEADER (DRAG, MINIMIZE, CLOSE) ==================
local header = Instance.new('Frame')
header.Size = UDim2.new(1, -4, 0, 30)
header.BackgroundTransparency = 1
header.LayoutOrder = 0
header.Parent = panel

local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -70, 1, 0) -- Dikasih ruang buat tombol kanan
title.Text = 'AliceHUB Split'
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.Parent = header

-- Tombol Minimize
local minBtn = Instance.new('TextButton')
minBtn.Size = UDim2.fromOffset(28, 28)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.Text = '—'
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Parent = header
local minCorner = Instance.new('UICorner'); minCorner.CornerRadius = UDim.new(0, 8); minCorner.Parent = minBtn

-- Tombol Close (X)
local closeBtn = Instance.new('TextButton')
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.Text = 'X'
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = header
local closeCorner = Instance.new('UICorner'); closeCorner.CornerRadius = UDim.new(0, 8); closeCorner.Parent = closeBtn

-- ================== SISTEM DRAG ==================
local UIS = game:GetService('UserInputService')
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
local function update(input)
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = panel.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- ================== LOGIKA MINIMIZE ==================
local isMinimized = false

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        -- Sembunyikan semua baris fitur di bawahnya
        for _, child in ipairs(panel:GetChildren()) do
            if child:IsA("Frame") and child.LayoutOrder and child.LayoutOrder >= 1 then
                child.Visible = false
            end
        end
        panel.Size = UDim2.fromOffset(340, 55) -- Ukuran kecil cuma buat header
        minBtn.Text = "+"
    else
        -- Tampilkan kembali semua baris fitur
        for _, child in ipairs(panel:GetChildren()) do
            if child:IsA("Frame") and child.LayoutOrder and child.LayoutOrder >= 1 then
                child.Visible = true
            end
        end
        panel.Size = UDim2.fromOffset(340, 400) -- Kembali ke ukuran semula
        minBtn.Text = "—"
    end
end

minBtn.MouseButton1Click:Connect(toggleMinimize)

-- ================== CLOSE ==================
closeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(threads) do if t then task.cancel(t) end end
    gui:Destroy()
end)


-- ================== FUNGSI PEMBUAT ROW KIRI-KANAN ==================
local orderIdx = 1

-- 1. Row Dropdown
local function createDropdownRow(labelText, options, onSelect)
    local row = Instance.new('Frame')
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = orderIdx
    orderIdx = orderIdx + 1
    row.Parent = panel

    local rowLayout = Instance.new('UIListLayout')
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = row

    local lbl = Instance.new('TextLabel')
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 230)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamSemibold
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = 1
    lbl.Parent = row

    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(0.55, 0, 1, 0)
    btn.Text = "▼ " .. options[1]
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = 2
    btn.Parent = row
    local bCorner = Instance.new('UICorner'); bCorner.CornerRadius = UDim.new(0, 6); bCorner.Parent = btn

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(0.55, 0, 0, 0)
    listFrame.AnchorPoint = Vector2.new(0, 1)
    listFrame.Position = UDim2.new(0.45, 0, 1, 5)
    listFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.ScrollBarThickness = 3
    listFrame.Visible = false
    listFrame.ZIndex = 5
    listFrame.Parent = row
    local lCorner = Instance.new('UICorner'); lCorner.CornerRadius = UDim.new(0, 8); lCorner.Parent = listFrame
    local lList = Instance.new('UIListLayout'); lList.Padding = UDim.new(0, 2); lList.Parent = listFrame

    local selected = options[1]
    local isOpen = false

    local function rebuildList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local totalH = 0
        for _, opt in ipairs(options) do
            local oBtn = Instance.new("TextButton")
            oBtn.Size = UDim2.new(1, 0, 0, 28)
            oBtn.Text = opt
            oBtn.TextSize = 12
            oBtn.Font = Enum.Font.Gotham
            oBtn.TextColor3 = Color3.new(1, 1, 1)
            oBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
            oBtn.BorderSizePixel = 0
            oBtn.Parent = listFrame
            local oCorner = Instance.new('UICorner'); oCorner.CornerRadius = UDim.new(0, 4); oCorner.Parent = oBtn
            
            oBtn.MouseButton1Click:Connect(function()
                selected = opt
                btn.Text = "▼ " .. opt
                listFrame.Visible = false
                isOpen = false
                if onSelect then onSelect(opt) end
            end)
            totalH = totalH + 30
        end
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalH)
    end
    rebuildList()

    btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listFrame.Visible = isOpen
        if isOpen then
            listFrame.Size = UDim2.new(0.55, 0, 0, math.min(#options * 30 + 4, 140))
        end
    end)

    return { getSelected = function() return selected end }
end

-- 2. Row Toggle (Sakelar On/Off)
local function createToggleRow(labelText, onToggle)
    local row = Instance.new('Frame')
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = orderIdx
    orderIdx = orderIdx + 1
    row.Parent = panel

    local rowLayout = Instance.new('UIListLayout')
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = row

    local lbl = Instance.new('TextLabel')
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 230)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamSemibold
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = 1
    lbl.Parent = row

    local btn = Instance.new('ImageButton')
    btn.Size = UDim2.new(0, 44, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = 2
    btn.Parent = row
    local bgCorner = Instance.new('UICorner'); bgCorner.CornerRadius = UDim.new(0, 12); bgCorner.Parent = btn

    local knob = Instance.new('ImageLabel')
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
            knob.Position = UDim2.new(1, -21, 0.5, -9)
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
            knob.Position = UDim2.new(0, 3, 0.5, -9)
        end
        onToggle(state, btn)
    end)
    return btn
end


-- ================== BUAT FITUR FARMING ==================
local throwDropdown = createDropdownRow("Throw Coin", coinList, function(opt) throwParams[3] = opt end)
local buyDropdown = createDropdownRow("Buy Coin", coinList)

createToggleRow("Auto Throw", function(on)
    state.throw = on
    if on then
        threads.throw = task.spawn(function()
            while state.throw do
                events.throw:FireServer(unpack(throwParams))
                task.wait(0.5)
            end
        end)
    elseif threads.throw then task.cancel(threads.throw); threads.throw = nil end
end)

createToggleRow("Auto Buy", function(on)
    state.buy = on
    if on then
        threads.buy = task.spawn(function()
            while state.buy do
                events.buy:FireServer(buyDropdown.getSelected())
                task.wait(0.5)
            end
        end)
    elseif threads.buy then task.cancel(threads.buy); threads.buy = nil end
end)

createToggleRow("Auto Sell All", function(on)
    state.sell = on
    if on then
        threads.sell = task.spawn(function()
            while state.sell do
                events.sell:FireServer()
                task.wait(0.5)
            end
        end)
    elseif threads.sell then task.cancel(threads.sell); threads.sell = nil end
end)

createToggleRow("Upgrade Luck", function(on)
    state.luck = on
    if on then
        threads.luck = task.spawn(function()
            while state.luck do
                events.upgrade:FireServer("Luck Multiplier")
                task.wait(0.5)
            end
        end)
    elseif threads.luck then task.cancel(threads.luck); threads.luck = nil end
end)

createToggleRow("Upgrade Value", function(on)
    state.value = on
    if on then
        threads.value = task.spawn(function()
            while state.value do
                events.upgrade:FireServer("Value Multiplier")
                task.wait(0.5)
            end
        end)
    elseif threads.value then task.cancel(threads.value); threads.value = nil end
end)

createToggleRow("AFK Safe", function(on)
    state.afk = on
    events.afk:FireServer(on)
end)

-- ================== CLEANUP ==================
player.CharacterAdded:Connect(function()
    for _, t in pairs(threads) do if t then task.cancel(t) end end
    threads = {}
    state = { throw = false, buy = false, sell = false, luck = false, value = false, afk = false }
end)

print("✅ AliceHUB (Split + Minimize) berhasil dimuat!")
