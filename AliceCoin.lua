local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- ================== DAFTAR COIN ALICEHUB ==================
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

-- ================== REMOTE EVENTS ALICEHUB ==================
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

-- ================== STRUKTUR GUI (PERSIS KAYAK PUNYA KAMU) ==================
local gui = Instance.new('ScreenGui')
gui.Name = 'AliceHUBCustom'
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild('PlayerGui')

local panel = Instance.new('Frame')
panel.Size = UDim2.fromOffset(320, 500) -- Dibikin agak tinggi biar muat semua tombol
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.new(0.5, 0, 1, -20)
panel.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
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
list.FillDirection = Enum.FillDirection.Vertical
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.Parent = panel

-- ================== HEADER (DRAG & CLOSE) ==================
local header = Instance.new('Frame')
header.Size = UDim2.new(1, -4, 0, 28)
header.BackgroundTransparency = 1
header.Parent = panel

local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -36, 1, 0)
title.Text = 'AliceHUB (Coin Farm)'
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.Parent = header

local closeBtn = Instance.new('TextButton')
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.Text = 'X'
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = header

local closeCorner = Instance.new('UICorner')
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    -- Hentikan semua thread farming
    for _, t in pairs(threads) do if t then task.cancel(t) end end
    gui:Destroy()
end)

-- ================== SISTEM DRAG (PERSIS PUNYA KAMU) ==================
local UIS = game:GetService('UserInputService')
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ================== FITUR DROPDOWN (COIN SELECT) ==================
-- Gue buat dropdown custom supaya tetap pakai gaya tombol yang kamu suka
local function makeDropdown(labelText, options, onSelect)
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1, -4, 0, 36)
    btn.Text = labelText .. ": " .. options[1]
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(240, 240, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
    btn.AutoButtonColor = true
    btn.Parent = panel

    local btnCorner = Instance.new('UICorner')
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 2)
    listFrame.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.ScrollBarThickness = 3
    listFrame.Visible = false
    listFrame.Parent = btn
    
    local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0, 8); lc.Parent = listFrame
    local listLayout = Instance.new("UIListLayout"); listLayout.Padding = UDim.new(0, 2); listLayout.Parent = listFrame

    local selected = options[1]
    local isOpen = false

    local function rebuildOptions()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local totalHeight = 0
        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.Text = opt
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextColor3 = Color3.new(1, 1, 1)
            optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            optBtn.BorderSizePixel = 0
            optBtn.Parent = listFrame
            local obCorner = Instance.new("UICorner"); obCorner.CornerRadius = UDim.new(0, 4); obCorner.Parent = optBtn
            
            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                btn.Text = labelText .. ": " .. opt
                listFrame.Visible = false
                isOpen = false
                if onSelect then onSelect(opt) end
            end)
            totalHeight = totalHeight + 30
        end
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    rebuildOptions()

    btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listFrame.Visible = isOpen
        if isOpen then
            listFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 30 + 4, 130))
        end
    end)

    return { getSelected = function() return selected end }
end

-- Helper tombol Switch (Tombol ON/OFF lebar 1 baris)
local function makeToggle(labelText, onToggle)
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1, -4, 0, 40)
    btn.Text = labelText .. ' (OFF)'
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(240, 240, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
    btn.AutoButtonColor = true
    btn.Parent = panel

    local btnCorner = Instance.new('UICorner')
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = labelText .. (state and ' (ON)' or ' (OFF)')
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(60, 110, 220)
        onToggle(state, btn)
    end)
    return btn
end

-- ================== CREATE UI ELEMENTS ==================
local throwDropdown = makeDropdown("Throw Coin", coinList, function(opt)
    throwParams[3] = opt
end)
local buyDropdown = makeDropdown("Buy Coin", coinList)

local throwToggle = makeToggle("Auto Throw", function(on)
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

local buyToggle = makeToggle("Auto Buy", function(on)
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

local sellToggle = makeToggle("Auto Sell All", function(on)
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

local luckToggle = makeToggle("Upgrade Luck", function(on)
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

local valueToggle = makeToggle("Upgrade Value", function(on)
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

local afkToggle = makeToggle("AFK Safe", function(on)
    state.afk = on
    events.afk:FireServer(on)
end)

-- Matiin semua thread kalau player mati/respawn
player.CharacterAdded:Connect(function()
    for _, t in pairs(threads) do if t then task.cancel(t) end end
    threads = {}
    state = { throw = false, buy = false, sell = false, luck = false, value = false, afk = false }
end)

print("✅ AliceHUB (Gaya Pootilities) berhasil dimuat!")
