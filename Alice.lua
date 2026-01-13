--// Alice Hub v1.2 (Refined Best Setting)
--// Fish Logger + Clean Cinematic UI
--// Delta Compatible

pcall(function()
    if game.CoreGui:FindFirstChild("AliceFloating") then
        game.CoreGui.AliceFloating:Destroy()
    end
    if game.CoreGui:FindFirstChild("RayfieldLibrary") then
        game.CoreGui.RayfieldLibrary:Destroy()
    end
end)

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

--// REQUEST
local request =
    (syn and syn.request) or
    (http and http.request) or
    http_request or
    (fluxus and fluxus.request)

--// CONFIG
local WEBHOOK_URL = ""
local ENABLE_LOGGER = true

local RARITY_TOGGLE = {
    Rare = true,
    Legendary = true,
    Mythic = true,
    Secret = true
}

--// RARITY COLORS
local RARITY_COLOR = {
    ["179,115,248"] = "Rare",
    ["255,185,43"]  = "Legendary",
    ["255,25,25"]   = "Mythic",
    ["24,255,152"]  = "Secret"
}

--// DISPLAY EVENT
local DisplaySystemMessage = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
    :WaitForChild("RE/DisplaySystemMessage")

--// UTILS
local function cleanText(text)
    text = tostring(text)
    text = text:gsub("<[^>]+>", "")
    text = text:gsub("%s+", " ")
    return text
end

local function getRarity(args)
    for _, v in ipairs(args) do
        if typeof(v) == "Color3" then
            local r = math.floor(v.R * 255)
            local g = math.floor(v.G * 255)
            local b = math.floor(v.B * 255)
            return RARITY_COLOR[r..","..g..","..b]
        end
    end
end

--// WEBHOOK
local function sendWebhook(args, rarity)
    if not request or WEBHOOK_URL == "" then return end
    if not ENABLE_LOGGER then return end
    if not RARITY_TOGGLE[rarity] then return end

    local content = "🎣 **Fish Caught!** ("..rarity..")\n```"
    for _, v in ipairs(args) do
        if typeof(v) ~= "Color3" then
            content ..= cleanText(v) .. "\n"
        end
    end
    content ..= "```"

    pcall(function()
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                username = "Alice Hub",
                content = content
            })
        })
    end)
end

DisplaySystemMessage.OnClientEvent:Connect(function(...)
    local args = {...}
    local rarity = getRarity(args)
    if rarity then
        sendWebhook(args, rarity)
    end
end)

--// LOAD RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Alice Hub",
    LoadingTitle = "Alice Hub",
    LoadingSubtitle = "Fish Logger",
    ConfigurationSaving = {Enabled = false}
})

--// BACKGROUND (BEST SETTING)
task.spawn(function()
    task.wait(1)

    local RF = game.CoreGui:FindFirstChild("RayfieldLibrary")
    if not RF then return end

    local Main = RF:FindFirstChild("Main", true)
    if not Main then return end

    -- Image Background
    local Bg = Instance.new("ImageLabel")
    Bg.Parent = Main
    Bg.Size = UDim2.new(1,0,1,0)
    Bg.Position = UDim2.new(0,0,0,0)
    Bg.Image = "https://files.catbox.moe/18el2l.jpg"
    Bg.BackgroundTransparency = 1
    Bg.ImageTransparency = 0.9 -- ⭐ BEST SPOT
    Bg.ScaleType = Enum.ScaleType.Crop
    Bg.ZIndex = 0

    -- Dark Overlay (Cinematic)
    local Dark = Instance.new("Frame")
    Dark.Parent = Main
    Dark.Size = UDim2.new(1,0,1,0)
    Dark.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    Dark.BackgroundTransparency = 0.75
    Dark.ZIndex = 1

    -- Lift UI above background
    for _, v in ipairs(Main:GetChildren()) do
        if v:IsA("GuiObject") and v ~= Bg and v ~= Dark then
            v.ZIndex += 2
        end
    end
end)

--// TAB
local Tab = Window:CreateTab("🎣 Fish Logger", 4483362458)

Tab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "https://discord.com/api/webhooks/...",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        WEBHOOK_URL = v
    end
})

Tab:CreateToggle({
    Name = "Enable Logger",
    CurrentValue = true,
    Callback = function(v)
        ENABLE_LOGGER = v
    end
})

Tab:CreateSection("Rarity Filter")

for rarity in pairs(RARITY_TOGGLE) do
    Tab:CreateToggle({
        Name = rarity,
        CurrentValue = true,
        Callback = function(v)
            RARITY_TOGGLE[rarity] = v
        end
    })
end

--// FLOATING BUTTON + GLOW
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AliceFloating"

local Glow = Instance.new("ImageLabel", ScreenGui)
Glow.Size = UDim2.fromOffset(90,90)
Glow.Position = UDim2.fromScale(0.92,0.5)
Glow.AnchorPoint = Vector2.new(0.5,0.5)
Glow.Image = "https://files.catbox.moe/18el2l.jpg"
Glow.BackgroundTransparency = 1
Glow.ImageTransparency = 0.45
Glow.ZIndex = 998
Instance.new("UICorner", Glow).CornerRadius = UDim.new(1,0)

local Button = Instance.new("ImageButton", ScreenGui)
Button.Size = UDim2.fromOffset(60,60)
Button.Position = Glow.Position
Button.AnchorPoint = Vector2.new(0.5,0.5)
Button.Image = "https://files.catbox.moe/18el2l.jpg"
Button.BackgroundTransparency = 1
Button.ZIndex = 999
Instance.new("UICorner", Button).CornerRadius = UDim.new(1,0)

--// DRAG
local dragging, dragStart, startPos

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        Button.Position = newPos
        Glow.Position = newPos
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--// TOGGLE UI
local opened = true
Button.MouseButton1Click:Connect(function()
    opened = not opened
    Rayfield:SetVisibility(opened)
end)
