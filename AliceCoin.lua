--[[
    ╔══════════════════════════════════════╗
             AliceHUB v2
        Clean UI / Stable Structure
    ╚══════════════════════════════════════╝
]]

-- =========================================================
-- SERVICES
-- =========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =========================================================
-- CONFIG
-- =========================================================

local CONFIG = {
    PanelWidth = 340,
    PanelHeight = 400,

    Background = Color3.fromRGB(30, 32, 40),
    Secondary = Color3.fromRGB(40, 45, 60),
    DropdownBackground = Color3.fromRGB(25, 28, 35),

    Text = Color3.fromRGB(235, 235, 245),
    SecondaryText = Color3.fromRGB(200, 200, 230),

    ToggleOff = Color3.fromRGB(50, 55, 65),
    ToggleOn = Color3.fromRGB(80, 200, 100),

    LoopDelay = 0.5,
}

-- =========================================================
-- COIN LIST
-- =========================================================

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

-- =========================================================
-- REMOTES
-- =========================================================

local events = {
    throw = ReplicatedStorage.Assets.Events.CoinLanded,
    buy = ReplicatedStorage.Assets.Events.BuyCoin,
    sell = ReplicatedStorage.Assets.Events.SellAll,
    upgrade = ReplicatedStorage.Assets.Events.RequestUpgrade,
    afk = ReplicatedStorage.Assets.Events.SetAFKSafe,
}

-- =========================================================
-- STATE
-- =========================================================

local state = {
    throw = false,
    buy = false,
    sell = false,
    luck = false,
    value = false,
    afk = false,
}

local threads = {}
local connections = {}

local throwCoin = coinList[1]
local buyCoin = coinList[1]

local destroyed = false
local minimized = false

-- =========================================================
-- CONNECTION MANAGER
-- =========================================================

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function disconnectAll()
    for _, connection in ipairs(connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end

    table.clear(connections)
end

-- =========================================================
-- THREAD MANAGER
-- =========================================================

local function stopThread(name)
    local thread = threads[name]

    if thread then
        pcall(function()
            task.cancel(thread)
        end)

        threads[name] = nil
    end
end

local function stopAllThreads()
    for name in pairs(threads) do
        stopThread(name)
    end
end

local function startLoop(name, callback)
    stopThread(name)

    threads[name] = task.spawn(function()
        while not destroyed and state[name] do
            local success, err = pcall(callback)

            if not success then
                warn("[AliceHUB] " .. name .. " error:", err)
            end

            task.wait(CONFIG.LoopDelay)
        end

        threads[name] = nil
    end)
end

-- =========================================================
-- DESTROY OLD GUI
-- =========================================================

local oldGui = playerGui:FindFirstChild("AliceHUBv2")

if oldGui then
    oldGui:Destroy()
end

-- =========================================================
-- MAIN GUI
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "AliceHUBv2"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- =========================================================
-- PANEL
-- =========================================================

local panel = Instance.new("ScrollingFrame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(CONFIG.PanelWidth, CONFIG.PanelHeight)
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.new(0.5, 0, 1, -15)
panel.BackgroundColor3 = CONFIG.Background
panel.BorderSizePixel = 0
panel.ScrollBarThickness = 4
panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
panel.CanvasSize = UDim2.new(0, 0, 0, 0)
panel.Active = true
panel.ScrollingEnabled = true
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = panel

-- =========================================================
-- HEADER
-- =========================================================

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -4, 0, 30)
header.BackgroundTransparency = 1
header.LayoutOrder = 0
header.Active = true
header.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -70, 1, 0)
title.Text = "AliceHUB v2"
title.TextColor3 = CONFIG.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.Parent = header

-- =========================================================
-- MINIMIZE
-- =========================================================

local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.fromOffset(28, 28)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- =========================================================
-- CLOSE
-- =========================================================

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- =========================================================
-- DRAG SYSTEM
-- =========================================================

local dragging = false
local dragStart
local startPosition
local dragInput

local function updateDrag(input)
    if not dragging then
        return
    end

    local delta = input.Position - dragStart

    panel.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

connect(header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

connect(header.InputChanged, function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end
end)

connect(UIS.InputChanged, function(input)
    if input == dragInput then
        updateDrag(input)
    end
end)

-- =========================================================
-- DROPDOWN REGISTRY
-- =========================================================

local dropdowns = {}

local function closeAllDropdowns(except)
    for dropdown in pairs(dropdowns) do
        if dropdown ~= except then
            dropdown:Close()
        end
    end
end

-- =========================================================
-- DROPDOWN
-- =========================================================

local function createDropdownRow(labelText, options, callback)

    local row = Instance.new("Frame")
    row.Name = labelText:gsub("%s+", "")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = #panel:GetChildren() + 1
    row.Parent = panel

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    rowLayout.Parent = row

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = CONFIG.SecondaryText
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    -- Button
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.55, 0, 1, 0)
    button.Text = "▼ " .. options[1]
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = CONFIG.Secondary
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = row

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    -- Dropdown
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Name = labelText .. "_Dropdown"
    dropdown.BackgroundColor3 = CONFIG.DropdownBackground
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.ScrollBarThickness = 3
    dropdown.Visible = false
    dropdown.ZIndex = 100
    dropdown.Parent = gui

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    dropdownCorner.Parent = dropdown

    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Padding = UDim.new(0, 2)
    dropdownLayout.Parent = dropdown

    local selected = options[1]
    local opened = false

    local api = {}

    function api:GetSelected()
        return selected
    end

    function api:Close()
        opened = false
        dropdown.Visible = false
    end

    function api:Open()
        closeAllDropdowns(api)

        local absolutePosition = button.AbsolutePosition
        local absoluteSize = button.AbsoluteSize

        local height = math.min(
            (#options * 30) + 4,
            160
        )

        dropdown.Position = UDim2.fromOffset(
            absolutePosition.X,
            absolutePosition.Y + absoluteSize.Y
        )

        dropdown.Size = UDim2.fromOffset(
            absoluteSize.X,
            height
        )

        dropdown.CanvasSize = UDim2.fromOffset(
            0,
            (#options * 30) + 4
        )

        dropdown.Visible = true
        opened = true
    end

    dropdowns[api] = true

    -- Create options
    for _, option in ipairs(options) do

        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 28)
        optionButton.Text = option
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextColor3 = Color3.new(1, 1, 1)
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
        optionButton.BorderSizePixel = 0
        optionButton.AutoButtonColor = false
        optionButton.ZIndex = 101
        optionButton.Parent = dropdown

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton

        connect(optionButton.MouseButton1Click, function()

            selected = option

            button.Text = "▼ " .. option

            api:Close()

            if callback then
                callback(option)
            end
        end)
    end

    connect(button.MouseButton1Click, function()

        if opened then
            api:Close()
        else
            api:Open()
        end
    end)

    return api
end

-- =========================================================
-- CLOSE DROPDOWNS WHEN CLICKING OUTSIDE
-- =========================================================

connect(UIS.InputBegan, function(input)

    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local position = input.Position

    for dropdownApi in pairs(dropdowns) do

        -- Dropdown itself handles its own clicks.
        -- Here we simply close open dropdowns when appropriate.
        local dropdownObject

        for _, object in ipairs(gui:GetChildren()) do
            if object:IsA("ScrollingFrame")
                and object.Name:find("_Dropdown") then

                dropdownObject = object

                if object.Visible then

                    local p = object.AbsolutePosition
                    local s = object.AbsoluteSize

                    local inside =
                        position.X >= p.X
                        and position.X <= p.X + s.X
                        and position.Y >= p.Y
                        and position.Y <= p.Y + s.Y

                    if not inside then
                        dropdownApi:Close()
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- TOGGLE
-- =========================================================

local toggleObjects = {}

local function createToggleRow(labelText, callback)

    local row = Instance.new("Frame")
    row.Name = labelText:gsub("%s+", "")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = #panel:GetChildren() + 1
    row.Parent = panel

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    rowLayout.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = CONFIG.SecondaryText
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local button = Instance.new("ImageButton")
    button.Size = UDim2.fromOffset(44, 24)
    button.BackgroundColor3 = CONFIG.ToggleOff
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = row

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = button

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = button

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local enabled = false

    local object = {}

    function object:Set(value, triggerCallback)

        enabled = value

        if enabled then
            button.BackgroundColor3 = CONFIG.ToggleOn
            knob.Position = UDim2.new(1, -21, 0.5, -9)
        else
            button.BackgroundColor3 = CONFIG.ToggleOff
            knob.Position = UDim2.new(0, 3, 0.5, -9)
        end

        if triggerCallback and callback then
            callback(enabled)
        end
    end

    function object:Get()
        return enabled
    end

    toggleObjects[labelText] = object

    connect(button.MouseButton1Click, function()

        object:Set(not enabled, true)

    end)

    return object
end

-- =========================================================
-- MINIMIZE
-- =========================================================

local function setMinimized(value)

    minimized = value

    for _, child in ipairs(panel:GetChildren()) do

        if child:IsA("Frame") and child ~= header then
            child.Visible = not minimized
        end
    end

    if minimized then
        panel.Size = UDim2.fromOffset(CONFIG.PanelWidth, 55)
        minBtn.Text = "+"
    else
        panel.Size = UDim2.fromOffset(
            CONFIG.PanelWidth,
            CONFIG.PanelHeight
        )

        minBtn.Text = "—"
    end
end

connect(minBtn.MouseButton1Click, function()
    setMinimized(not minimized)
end)

-- =========================================================
-- GAME LOGIC
-- =========================================================

local function startThrow()

    state.throw = true

    startLoop("throw", function()

        local throwParams = {
            1.4278748995675,
            Vector3.new(
                -1158.4721679688,
                0.72600001096725,
                -176.51705932617
            ),
            throwCoin,
            nil,
            nil,
            5
        }

        events.throw:FireServer(
            table.unpack(throwParams, 1, 6)
        )
    end)
end

local function startBuy()

    state.buy = true

    startLoop("buy", function()
        events.buy:FireServer(buyCoin)
    end)
end

local function startSell()

    state.sell = true

    startLoop("sell", function()
        events.sell:FireServer()
    end)
end

local function startLuck()

    state.luck = true

    startLoop("luck", function()
        events.upgrade:FireServer("Luck Multiplier")
    end)
end

local function startValue()

    state.value = true

    startLoop("value", function()
        events.upgrade:FireServer("Value Multiplier")
    end)
end

-- =========================================================
-- DROPDOWNS
-- =========================================================

local throwDropdown = createDropdownRow(
    "Throw Coin",
    coinList,
    function(option)
        throwCoin = option
    end
)

local buyDropdown = createDropdownRow(
    "Buy Coin",
    coinList,
    function(option)
        buyCoin = option
    end
)

-- =========================================================
-- TOGGLES
-- =========================================================

local throwToggle = createToggleRow(
    "Auto Throw",
    function(enabled)

        state.throw = enabled

        if enabled then
            startThrow()
        else
            stopThread("throw")
        end
    end
)

local buyToggle = createToggleRow(
    "Auto Buy",
    function(enabled)

        state.buy = enabled

        if enabled then
            startBuy()
        else
            stopThread("buy")
        end
    end
)

local sellToggle = createToggleRow(
    "Auto Sell All",
    function(enabled)

        state.sell = enabled

        if enabled then
            startSell()
        else
            stopThread("sell")
        end
    end
)

local luckToggle = createToggleRow(
    "Upgrade Luck",
    function(enabled)

        state.luck = enabled

        if enabled then
            startLuck()
        else
            stopThread("luck")
        end
    end
)

local valueToggle = createToggleRow(
    "Upgrade Value",
    function(enabled)

        state.value = enabled

        if enabled then
            startValue()
        else
            stopThread("value")
        end
    end
)

local afkToggle = createToggleRow(
    "AFK Safe",
    function(enabled)

        state.afk = enabled

        pcall(function()
            events.afk:FireServer(enabled)
        end)
    end
)

-- =========================================================
-- RESPAWN HANDLING
-- =========================================================

connect(player.CharacterAdded, function()

    -- Stop all active loops
    stopAllThreads()

    -- Reset state
    state.throw = false
    state.buy = false
    state.sell = false
    state.luck = false
    state.value = false
    state.afk = false

    -- Reset UI toggles
    throwToggle:Set(false, false)
    buyToggle:Set(false, false)
    sellToggle:Set(false, false)
    luckToggle:Set(false, false)
    valueToggle:Set(false, false)
    afkToggle:Set(false, false)

end)

-- =========================================================
-- CLOSE / CLEANUP
-- =========================================================

local function cleanup()

    if destroyed then
        return
    end

    destroyed = true

    -- Stop loops
    stopAllThreads()

    -- Disconnect events
    disconnectAll()

    -- Clear dropdown registry
    table.clear(dropdowns)

    -- Destroy GUI
    if gui then
        gui:Destroy()
    end
end

connect(closeBtn.MouseButton1Click, cleanup)

-- =========================================================
-- FINAL
-- =========================================================

print("✅ AliceHUB v2 berhasil dimuat!")
