--[[
╔════════════════════════════════════════════╗
              ALICEHUB v3
        Mobile • Tab • Card UI
╚════════════════════════════════════════════╝
]]

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    Width = 360,
    Height = 455,

    Background = Color3.fromRGB(24, 26, 33),
    Card = Color3.fromRGB(31, 34, 43),
    Card2 = Color3.fromRGB(37, 40, 51),

    Button = Color3.fromRGB(44, 48, 61),
    Dropdown = Color3.fromRGB(28, 31, 40),

    Text = Color3.fromRGB(242, 242, 248),
    SubText = Color3.fromRGB(157, 163, 178),

    Accent = Color3.fromRGB(105, 145, 255),
    ToggleOn = Color3.fromRGB(80, 195, 105),
    ToggleOff = Color3.fromRGB(58, 62, 74),

    Delay = 0.5,
}

--==================================================
-- COINS
--==================================================

local coinList = {
    "Basic Coin",
    "Copper Coin",
    "Fortune Coin",
    "Fire Coin",
    "Volt Coin",
    "Aether Coin",
    "Starlight Coin",
    "Galaxy Coin",
    "Void Coin",
    "Chronos Coin",
    "Eclipse Coin",
    "Mirage Coin",
    "Obsidian Coin",
    "Tempest Coin",
    "Soul Coin",
    "Paradox Coin",
    "Miracle Coin",
    "Nexus Coin",
    "Apex Coin",
    "Infinity Coin",
    "Grace Coin",
    "Dominion Coin",
    "Empyrean Coin",
    "Atlas Coin",
    "Judgement Coin",
    "Hercules Coin",
    "Helios Coin",
    "Nyx Coin",
    "Titan Coin",
    "Zeus Coin",
    "Runic Coin",
    "Amethyst Coin",
    "Merlin Coin",
    "Eldritch Coin",
    "Avalon Coin",
    "Dragonheart Coin",
    "Phoenix Coin",
}

--==================================================
-- REMOTES
--==================================================

local Events = {
    Throw = ReplicatedStorage.Assets.Events.CoinLanded,
    Buy = ReplicatedStorage.Assets.Events.BuyCoin,
    Sell = ReplicatedStorage.Assets.Events.SellAll,
    Upgrade = ReplicatedStorage.Assets.Events.RequestUpgrade,
    AFK = ReplicatedStorage.Assets.Events.SetAFKSafe,
}

--==================================================
-- STATE
--==================================================

local State = {
    Throw = false,
    Buy = false,
    Sell = false,
    Luck = false,
    Value = false,
    AFK = false,
}

local Selected = {
    Throw = coinList[1],
    Buy = coinList[1],
}

local Threads = {}
local Connections = {}
local Toggles = {}
local Tabs = {}
local Dropdowns = {}

local Destroyed = false
local Minimized = false
local CurrentTab = "COIN"

--==================================================
-- CONNECTION MANAGER
--==================================================

local function Connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(Connections, c)
    return c
end

local function DisconnectAll()
    for _, c in ipairs(Connections) do
        if c and c.Connected then
            c:Disconnect()
        end
    end

    table.clear(Connections)
end

--==================================================
-- THREAD MANAGER
--==================================================

local function StopThread(name)
    if Threads[name] then
        pcall(function()
            task.cancel(Threads[name])
        end)

        Threads[name] = nil
    end
end

local function StopAllThreads()
    for name in pairs(Threads) do
        StopThread(name)
    end
end

local function StartLoop(name, callback)
    StopThread(name)

    Threads[name] = task.spawn(function()
        while not Destroyed and State[name] do

            local ok, err = pcall(callback)

            if not ok then
                warn("[AliceHUB] " .. name .. ":", err)
            end

            task.wait(CONFIG.Delay)
        end

        Threads[name] = nil
    end)
end

--==================================================
-- REMOVE OLD GUI
--==================================================

local Old = PlayerGui:FindFirstChild("AliceHUBv3")

if Old then
    Old:Destroy()
end

--==================================================
-- SCREEN GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "AliceHUBv3"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

--==================================================
-- MAIN PANEL
--==================================================

local Panel = Instance.new("Frame")
Panel.Name = "Main"
Panel.Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height)
Panel.AnchorPoint = Vector2.new(0.5, 1)
Panel.Position = UDim2.new(0.5, 0, 1, -15)
Panel.BackgroundColor3 = CONFIG.Background
Panel.BorderSizePixel = 0
Panel.Active = true
Panel.Parent = GUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 14)
PanelCorner.Parent = Panel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(48, 52, 65)
PanelStroke.Thickness = 1
PanelStroke.Transparency = 0.25
PanelStroke.Parent = Panel

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 46)
Header.Position = UDim2.fromOffset(10, 8)
Header.BackgroundTransparency = 1
Header.Active = true
Header.Parent = Panel

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromOffset(35, 35)
Logo.Position = UDim2.fromOffset(0, 5)
Logo.BackgroundColor3 = CONFIG.Accent
Logo.Text = "A"
Logo.TextColor3 = Color3.new(1, 1, 1)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 18
Logo.Parent = Header

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -125, 0, 22)
Title.Position = UDim2.fromOffset(45, 4)
Title.BackgroundTransparency = 1
Title.Text = "AliceHUB"
Title.TextColor3 = CONFIG.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -125, 0, 18)
Subtitle.Position = UDim2.fromOffset(45, 24)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Coin automation"
Subtitle.TextColor3 = CONFIG.SubText
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.fromOffset(30, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = CONFIG.Button
MinBtn.Text = "—"
MinBtn.TextColor3 = CONFIG.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(30, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 62, 68)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 19
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

--==================================================
-- DRAG
--==================================================

local Dragging = false
local DragStart
local StartPosition
local DragInput

Connect(Header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Connect(Header.InputChanged, function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        DragInput = input
    end
end)

Connect(UIS.InputChanged, function(input)
    if Dragging and input == DragInput then

        local Delta = input.Position - DragStart

        Panel.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- TAB BAR
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 38)
TabBar.Position = UDim2.fromOffset(10, 60)
TabBar.BackgroundColor3 = CONFIG.Card
TabBar.BorderSizePixel = 0
TabBar.Parent = Panel

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 9)
TabCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = TabBar

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -145)
Content.Position = UDim2.fromOffset(10, 108)
Content.BackgroundTransparency = 1
Content.Parent = Panel

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 22)
Status.Position = UDim2.new(0, 10, 1, -30)
Status.BackgroundTransparency = 1
Status.Text = "● 0 features active"
Status.TextColor3 = CONFIG.SubText
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Panel

local function UpdateStatus()
    local count = 0

    for _, enabled in pairs(State) do
        if enabled then
            count += 1
        end
    end

    Status.Text = "● " .. count .. " feature" .. (count == 1 and "" or "s") .. " active"

    if count > 0 then
        Status.TextColor3 = CONFIG.ToggleOn
    else
        Status.TextColor3 = CONFIG.SubText
    end
end

--==================================================
-- CARD
--==================================================

local function CreateCard(title, height)

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, height)
    Card.BackgroundColor3 = CONFIG.Card
    Card.BorderSizePixel = 0
    Card.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 11)
    Corner.Parent = Card

    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -24, 0, 22)
    CardTitle.Position = UDim2.fromOffset(12, 8)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = CONFIG.Text
    CardTitle.Font = Enum.Font.GothamSemibold
    CardTitle.TextSize = 12
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card

    return Card
end

--==================================================
-- DROPDOWN
--==================================================

local function CreateDropdown(parent, y, options, default, callback)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -24, 0, 34)
    Button.Position = UDim2.fromOffset(12, y)
    Button.BackgroundColor3 = CONFIG.Button
    Button.BorderSizePixel = 0
    Button.Text = "▼  " .. default
    Button.TextColor3 = CONFIG.Text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    local SelectedValue = default
    local Open = false

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.fromOffset(1, 1)
    List.BackgroundColor3 = CONFIG.Dropdown
    List.BorderSizePixel = 0
    List.Visible = false
    List.ZIndex = 100
    List.ScrollBarThickness = 3
    List.Parent = GUI

    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = List

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = List

    local function Close()
        Open = false
        List.Visible = false
    end

    local function OpenList()
        for _, d in pairs(Dropdowns) do
            d()
        end

        local pos = Button.AbsolutePosition
        local size = Button.AbsoluteSize

        List.Position = UDim2.fromOffset(
            pos.X,
            pos.Y + size.Y + 3
        )

        List.Size = UDim2.fromOffset(
            size.X,
            math.min(#options * 29 + 4, 155)
        )

        List.CanvasSize = UDim2.fromOffset(
            0,
            #options * 29 + 4
        )

        List.Visible = true
        Open = true
    end

    table.insert(Dropdowns, Close)

    for _, option in ipairs(options) do

        local Option = Instance.new("TextButton")
        Option.Size = UDim2.new(1, 0, 0, 27)
        Option.BackgroundColor3 = CONFIG.Button
        Option.BorderSizePixel = 0
        Option.Text = option
        Option.TextColor3 = CONFIG.Text
        Option.Font = Enum.Font.Gotham
        Option.TextSize = 11
        Option.ZIndex = 101
        Option.Parent = List

        Connect(Option.MouseButton1Click, function()

            SelectedValue = option
            Button.Text = "▼  " .. option

            Close()

            if callback then
                callback(option)
            end
        end)
    end

    Connect(Button.MouseButton1Click, function()

        if Open then
            Close()
        else
            OpenList()
        end
    end)

    return function()
        return SelectedValue
    end
end

--==================================================
-- TOGGLE
--==================================================

local function CreateToggle(parent, y, title, description, key, callback)

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -24, 0, 45)
    Row.Position = UDim2.fromOffset(12, y)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1, -65, 0, 20)
    Name.Position = UDim2.fromOffset(0, 0)
    Name.BackgroundTransparency = 1
    Name.Text = title
    Name.TextColor3 = CONFIG.Text
    Name.Font = Enum.Font.GothamSemibold
    Name.TextSize = 12
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Row

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -65, 0, 17)
    Desc.Position = UDim2.fromOffset(0, 19)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = CONFIG.SubText
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 9
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Row

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.fromOffset(45, 24)
    Toggle.Position = UDim2.new(1, -45, 0, 8)
    Toggle.BackgroundColor3 = CONFIG.ToggleOff
    Toggle.Text = ""
    Toggle.BorderSizePixel = 0
    Toggle.AutoButtonColor = false
    Toggle.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(18, 18)
    Knob.Position = UDim2.fromOffset(3, 3)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local enabled = false

    local function Set(value, trigger)

        enabled = value
        State[key] = value

        if enabled then
            Toggle.BackgroundColor3 = CONFIG.ToggleOn
            Knob.Position = UDim2.new(1, -21, 0, 3)
        else
            Toggle.BackgroundColor3 = CONFIG.ToggleOff
            Knob.Position = UDim2.fromOffset(3, 3)
        end

        UpdateStatus()

        if trigger and callback then
            callback(enabled)
        end
    end

    Toggles[key] = {
        Set = Set,
        Get = function()
            return enabled
        end,
    }

    Connect(Toggle.MouseButton1Click, function()
        Set(not enabled, true)
    end)

    return Toggles[key]
end

--==================================================
-- TAB CREATION
--==================================================

local function CreateTab(name)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(105, 30)
    Button.BackgroundColor3 = CONFIG.Button
    Button.Text = name
    Button.TextColor3 = CONFIG.SubText
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 10
    Button.BorderSizePixel = 0
    Button.Parent = TabBar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    Tabs[name] = Button

    Connect(Button.MouseButton1Click, function()

        CurrentTab = name

        for tabName, tabButton in pairs(Tabs) do

            if tabName == CurrentTab then
                tabButton.BackgroundColor3 = CONFIG.Accent
                tabButton.TextColor3 = Color3.new(1, 1, 1)
            else
                tabButton.BackgroundColor3 = CONFIG.Button
                tabButton.TextColor3 = CONFIG.SubText
            end
        end

        for _, child in ipairs(Content:GetChildren()) do
            child.Visible = child.Name == name
        end
    end)

    return Button
end

CreateTab("COIN")
CreateTab("UPGRADE")
CreateTab("SYSTEM")

--==================================================
-- COIN TAB
--==================================================

local CoinTab = Instance.new("Frame")
CoinTab.Name = "COIN"
CoinTab.Size = UDim2.new(1, 0, 1, 0)
CoinTab.BackgroundTransparency = 1
CoinTab.Parent = Content

local CoinLayout = Instance.new("UIListLayout")
CoinLayout.Padding = UDim.new(0, 8)
CoinLayout.Parent = CoinTab

local ThrowCard = CreateCard("THROW COIN", 125)
ThrowCard.Parent = CoinTab

CreateDropdown(
    ThrowCard,
    35,
    coinList,
    Selected.Throw,
    function(option)
        Selected.Throw = option
    end
)

CreateToggle(
    ThrowCard,
    76,
    "Auto Throw",
    "Automatically throw selected coin",
    "Throw",
    function(enabled)
        if enabled then
            StartLoop("Throw", function()

                local params = {
                    1.4278748995675,
                    Vector3.new(
                        -1158.4721679688,
                        0.72600001096725,
                        -176.51705932617
                    ),
                    Selected.Throw,
                    nil,
                    nil,
                    5
                }

                Events.Throw:FireServer(
                    table.unpack(params, 1, 6)
                )
            end)
        else
            StopThread("Throw")
        end
    end
)

local BuyCard = CreateCard("BUY & SELL", 160)
BuyCard.Parent = CoinTab

CreateDropdown(
    BuyCard,
    35,
    coinList,
    Selected.Buy,
    function(option)
        Selected.Buy = option
    end
)

CreateToggle(
    BuyCard,
    76,
    "Auto Buy",
    "Automatically buy selected coin",
    "Buy",
    function(enabled)
        if enabled then
            StartLoop("Buy", function()
                Events.Buy:FireServer(Selected.Buy)
            end)
        else
            StopThread("Buy")
        end
    end
)

CreateToggle(
    BuyCard,
    121,
    "Auto Sell All",
    "Automatically sell all coins",
    "Sell",
    function(enabled)
        if enabled then
            StartLoop("Sell", function()
                Events.Sell:FireServer()
            end)
        else
            StopThread("Sell")
        end
    end
)

--==================================================
-- UPGRADE TAB
--==================================================

local UpgradeTab = Instance.new("Frame")
UpgradeTab.Name = "UPGRADE"
UpgradeTab.Size = UDim2.new(1, 0, 1, 0)
UpgradeTab.BackgroundTransparency = 1
UpgradeTab.Visible = false
UpgradeTab.Parent = Content

local UpgradeLayout = Instance.new("UIListLayout")
UpgradeLayout.Padding = UDim.new(0, 8)
UpgradeLayout.Parent = UpgradeTab

local UpgradeCard = CreateCard("UPGRADES", 150)
UpgradeCard.Parent = UpgradeTab

CreateToggle(
    UpgradeCard,
    38,
    "Upgrade Luck",
    "Automatically request Luck upgrade",
    "Luck",
    function(enabled)
        if enabled then
            StartLoop("Luck", function()
                Events.Upgrade:FireServer("Luck Multiplier")
            end)
        else
            StopThread("Luck")
        end
    end
)

CreateToggle(
    UpgradeCard,
    83,
    "Upgrade Value",
    "Automatically request Value upgrade",
    "Value",
    function(enabled)
        if enabled then
            StartLoop("Value", function()
                Events.Upgrade:FireServer("Value Multiplier")
            end)
        else
            StopThread("Value")
        end
    end
)

--==================================================
-- SYSTEM TAB
--==================================================

local SystemTab = Instance.new("Frame")
SystemTab.Name = "SYSTEM"
SystemTab.Size = UDim2.new(1, 0, 1, 0)
SystemTab.BackgroundTransparency = 1
SystemTab.Visible = false
SystemTab.Parent = Content

local SystemLayout = Instance.new("UIListLayout")
SystemLayout.Padding = UDim.new(0, 8)
SystemLayout.Parent = SystemTab

local SystemCard = CreateCard("SYSTEM", 105)
SystemCard.Parent = SystemTab

CreateToggle(
    SystemCard,
    38,
    "AFK Safe",
    "Enable AFK safe mode",
    "AFK",
    function(enabled)
        pcall(function()
            Events.AFK:FireServer(enabled)
        end)
    end
)

--==================================================
-- INITIAL TAB
--==================================================

Tabs.COIN.BackgroundColor3 = CONFIG.Accent
Tabs.COIN.TextColor3 = Color3.new(1, 1, 1)

--==================================================
-- MINIMIZE
--==================================================

local function SetMinimized(value)

    Minimized = value

    TabBar.Visible = not value
    Content.Visible = not value
    Status.Visible = not value

    if value then
        Panel.Size = UDim2.fromOffset(CONFIG.Width, 65)
        MinBtn.Text = "+"
    else
        Panel.Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height)
        MinBtn.Text = "—"
    end
end

Connect(MinBtn.MouseButton1Click, function()
    SetMinimized(not Minimized)
end)

--==================================================
-- RESPAWN
--==================================================

Connect(Player.CharacterAdded, function()

    StopAllThreads()

    for key, toggle in pairs(Toggles) do
        toggle.Set(false, false)
    end

    for key in pairs(State) do
        State[key] = false
    end

    UpdateStatus()
end)

--==================================================
-- CLEANUP
--==================================================

local function Cleanup()

    if Destroyed then
        return
    end

    Destroyed = true

    StopAllThreads()
    DisconnectAll()

    table.clear(Toggles)
    table.clear(Tabs)
    table.clear(Dropdowns)

    if GUI then
        GUI:Destroy()
    end
end

CloseBtn.MouseButton1Click:Connect(Cleanup)

--==================================================
-- DONE
--==================================================

UpdateStatus()

print("✅ AliceHUB v3 loaded successfully!")
