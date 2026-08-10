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

-- ================== LIBRARY UI PASARAN (2 KOLOM, ANTI BUG) ==================
local Library = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "aliceHUB"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 310)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MF_Corner = Instance.new("UICorner")
MF_Corner.CornerRadius = UDim.new(0, 12)
MF_Corner.Parent = MainFrame

local Scroller = Instance.new("ScrollingFrame")
Scroller.Size = UDim2.new(1, 0, 1, 0)
Scroller.BackgroundTransparency = 1
Scroller.BorderSizePixel = 0
Scroller.ScrollBarThickness = 3
Scroller.Parent = MainFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = Scroller

-- ================== HEADER ==================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = Scroller

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 0.6, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "✦ aliceHUB ✦"
Title.TextColor3 = Color3.fromRGB(220, 200, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(0.7, 0, 0.4, 0)
Sub.Position = UDim2.new(0, 0, 0.6, 0)
Sub.Text = "Auto Farm Controller"
Sub.TextColor3 = Color3.fromRGB(140, 140, 180)
Sub.TextSize = 10
Sub.Font = Enum.Font.Gotham
Sub.BackgroundTransparency = 1
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 22)
CloseBtn.Position = UDim2.new(1, -25, 0.5, -11)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
local C_Corner = Instance.new("UICorner"); C_Corner.CornerRadius = UDim.new(0, 6); C_Corner.Parent = CloseBtn

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Divider.BorderSizePixel = 0
Divider.Parent = Scroller

-- ================== DROPDOWN COIN ==================
local DropdownContainer = Instance.new("Frame")
DropdownContainer.Size = UDim2.new(1, 0, 0, 70) -- Tempat untuk 2 dropdown
DropdownContainer.BackgroundTransparency = 1
DropdownContainer.Parent = Scroller

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Padding = UDim.new(0, 6)
DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropdownLayout.Parent = DropdownContainer

local function createDropdown(labelText, options, order)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 34)
    Container.BackgroundTransparency = 1
    Container.LayoutOrder = order
    Container.Parent = DropdownContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.3, 0, 1, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 230)
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.65, 0, 0.8, 0)
    Button.Position = UDim2.new(0.3, 0, 0.1, 0)
    Button.Text = "▼ " .. options[1]
    Button.TextSize = 10
    Button.Font = Enum.Font.GothamSemibold
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Parent = Container
    local B_Corner = Instance.new("UICorner"); B_Corner.CornerRadius = UDim.new(0, 5); B_Corner.Parent = Button

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(0.65, 0, 0, 0)
    List.Position = UDim2.new(0.3, 0, 0.9, 0)
    List.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    List.BorderSizePixel = 0
    List.ClipsDescendants = true
    List.ScrollBarThickness = 3
    List.Parent = Container
    local L_Corner = Instance.new("UICorner"); L_Corner.CornerRadius = UDim.new(0, 5); L_Corner.Parent = List
    
    local L_Layout = Instance.new("UIListLayout")
    L_Layout.Padding = UDim.new(0, 2)
    L_Layout.SortOrder = Enum.SortOrder.LayoutOrder
    L_Layout.Parent = List

    local selected = options[1]
    local totalH = 0
    
    for _, opt in ipairs(options) do
        local Item = Instance.new("TextButton")
        Item.Size = UDim2.new(1, 0, 0, 24)
        Item.Text = opt
        Item.TextSize = 10
        Item.Font = Enum.Font.Gotham
        Item.TextColor3 = Color3.fromRGB(220, 220, 255)
        Item.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Item.BorderSizePixel = 0
        Item.Parent = List
        local I_Corner = Instance.new("UICorner"); I_Corner.CornerRadius = UDim.new(0, 3); I_Corner.Parent = Item
        
        Item.MouseButton1Click:Connect(function()
            selected = opt
            Button.Text = "▼ " .. opt
            List.Size = UDim2.new(0.65, 0, 0, 0)
        end)
        totalH = totalH + 26
    end
    List.CanvasSize = UDim2.new(0, 0, 0, totalH)

    Button.MouseButton1Click:Connect(function()
        if List.Size.Y.Offset > 0 then
            List.Size = UDim2.new(0.65, 0, 0, 0)
        else
            List.Size = UDim2.new(0.65, 0, 0, math.min(totalH, 120))
        end
    end)

    return { get = function() return selected end }
end

local ThrowDrop = createDropdown("Throw Coin", coinList, 1)
local BuyDrop = createDropdown("Buy Coin", coinList, 2)

-- ================== GRID TOMBOL SWITCH (2 KOLOM) ==================
local GridContainer = Instance.new("Frame")
GridContainer.Size = UDim2.new(1, 0, 0, 110)
GridContainer.BackgroundTransparency = 1
GridContainer.Parent = Scroller

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0.5, -3, 0, 32)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.Parent = GridContainer

local function createSwitch(labelText, order, onToggle)
    local Item = Instance.new("Frame")
    Item.Size = UDim2.new(1, 0, 1, 0)
    Item.BackgroundTransparency = 1
    Item.LayoutOrder = order
    Item.Parent = GridContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(230, 230, 255)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamSemibold
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Item

    local Btn = Instance.new("ImageButton")
    Btn.Size = UDim2.new(0, 34, 0, 18)
    Btn.Position = UDim2.new(1, -34, 0.5, -9)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Btn.BorderSizePixel = 0
    Btn.Image = "rbxassetid://3570695787"
    Btn.ScaleType = Enum.ScaleType.Slice
    Btn.SliceCenter = Rect.new(4, 4, 12, 12)
    Btn.Parent = Item

    local Knob = Instance.new("ImageLabel")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(0, 3, 0.5, -6)
    Knob.BackgroundTransparency = 1
    Knob.Image = "rbxassetid://3926305904"
    Knob.Parent = Btn

    local state = false
    local function update(newState)
        state = newState
        if state then
            Btn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
            Knob.Position = UDim2.new(1, -15, 0.5, -6)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            Knob.Position = UDim2.new(0, 3, 0.5, -6)
        end
        if onToggle then onToggle(state) end
    end
    Btn.MouseButton1Click:Connect(function() update(not state) end)

    return { toggle = function() update(not state) end }
end

-- ================== LOGIC FITUR ==================
local states = { throw = false, buy = false, sell = false, luck = false, value = false, afk = false }
local threads = {}

local T_Throw = createSwitch("Auto Throw", 1, function(s)
    states.throw = s
    if s then
        threads.throw = task.spawn(function()
            while states.throw do
                events.throw:FireServer(unpack(throwParams))
                task.wait(0.5)
            end
        end)
    elseif threads.throw then task.cancel(threads.throw) end
end)

local T_Buy = createSwitch("Auto Buy", 2, function(s)
    states.buy = s
    if s then
        threads.buy = task.spawn(function()
            while states.buy do
                events.buy:FireServer(BuyDrop.get())
                task.wait(0.5)
            end
        end)
    elseif threads.buy then task.cancel(threads.buy) end
end)

local T_Sell = createSwitch("Auto Sell", 3, function(s)
    states.sell = s
    if s then
        threads.sell = task.spawn(function()
            while states.sell do
                events.sell:FireServer()
                task.wait(0.5)
            end
        end)
    elseif threads.sell then task.cancel(threads.sell) end
end)

local T_Luck = createSwitch("Luck Upgrade", 4, function(s)
    states.luck = s
    if s then
        threads.luck = task.spawn(function()
            while states.luck do
                events.upgrade:FireServer("Luck Multiplier")
                task.wait(0.5)
            end
        end)
    elseif threads.luck then task.cancel(threads.luck) end
end)

local T_Value = createSwitch("Value Upgrade", 5, function(s)
    states.value = s
    if s then
        threads.value = task.spawn(function()
            while states.value do
                events.upgrade:FireServer("Value Multiplier")
                task.wait(0.5)
            end
        end)
    elseif threads.value then task.cancel(threads.value) end
end)

local T_AFK = createSwitch("AFK Safe", 6, function(s)
    states.afk = s
    events.afk:FireServer(s)
end)

-- ================== CLOSE & CLEANUP ==================
CloseBtn.MouseButton1Click:Connect(function()
    for _, name in ipairs({"throw","buy","sell","luck","value"}) do
        if threads[name] then task.cancel(threads[name]) end
    end
    ScreenGui:Destroy()
end)

print("🎯 aliceHUB (GUI Pasaran) Siap! Gak akan ilang lagi.")
