-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

-- ================== KONFIGURASI GAME (ALICE LOGIC) ==================
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

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

-- ================== LUNA UI ==================
local Window = Luna:CreateWindow({
	Name = "AliceHUB",
	Subtitle = "Premium Luna Edition",
	LogoID = "82795327169782",
	LoadingEnabled = true,
	LoadingTitle = "Luna Interface Suite",
	LoadingSubtitle = "Loading AliceHUB...",
	ConfigSettings = {
		RootFolder = nil,
		ConfigFolder = "AliceHUB Configs"
	},
	KeySystem = false,
	KeySettings = {
		Title = "Key System",
		Subtitle = "Key System",
		Note = "No Key Required",
		SaveInRoot = false,
		SaveKey = true,
		Key = {"Free"},
		SecondAction = {
			Enabled = false,
			Type = "Link",
			Parameter = ""
		}
	}
})

-- Tab Utama
local Tab = Window:CreateTab({
	Name = "Auto Farm",
	Icon = "rocket_launch",
	ImageSource = "Material",
	ShowTitle = true
})

-- Info Paragraph
local Paragraph = Tab:CreateParagraph({
	Title = "AliceHUB Auto Farm Controller",
	Text = "Easy and efficient auto farming for Coin Game. Made by Alice."
})

-- Dropdown List Coin
local ThrowDropdown = Tab:CreateDropdown({
	Name = "Throw Coin Target",
	Options = coinList,
	CurrentOption = {coinList[1]},
	MultipleOptions = false,
	Callback = function(opt)
		throwParams[3] = opt
	end
}, "ThrowCoin")

local BuyDropdown = Tab:CreateDropdown({
	Name = "Buy Coin Target",
	Options = coinList,
	CurrentOption = {coinList[1]},
	MultipleOptions = false,
	Callback = function(opt)
		-- Logic langsung di handle oleh toggle
	end
}, "BuyCoin")

-- Divider alias Label
Tab:CreateLabel({
	Text = "--- Auto Toggles ---",
	Style = 1
})

-- 1. Auto Throw
local ThrowToggle = Tab:CreateToggle({
	Name = "Auto Throw",
	CurrentValue = false,
	Callback = function(Value)
		state.throw = Value
		if Value then
			threads.throw = task.spawn(function()
				while state.throw do
					events.throw:FireServer(unpack(throwParams))
					task.wait(0.5)
				end
			end)
		elseif threads.throw then
			task.cancel(threads.throw)
			threads.throw = nil
		end
	end
}, "AutoThrow")

-- 2. Auto Buy
local BuyToggle = Tab:CreateToggle({
	Name = "Auto Buy",
	CurrentValue = false,
	Callback = function(Value)
		state.buy = Value
		if Value then
			threads.buy = task.spawn(function()
				while state.buy do
					events.buy:FireServer(BuyDropdown.CurrentOption[1])
					task.wait(0.5)
				end
			end)
		elseif threads.buy then
			task.cancel(threads.buy)
			threads.buy = nil
		end
	end
}, "AutoBuy")

-- 3. Auto Sell All
local SellToggle = Tab:CreateToggle({
	Name = "Auto Sell All",
	CurrentValue = false,
	Callback = function(Value)
		state.sell = Value
		if Value then
			threads.sell = task.spawn(function()
				while state.sell do
					events.sell:FireServer()
					task.wait(0.5)
				end
			end)
		elseif threads.sell then
			task.cancel(threads.sell)
			threads.sell = nil
		end
	end
}, "AutoSell")

-- 4. Upgrade Luck
local LuckToggle = Tab:CreateToggle({
	Name = "Upgrade Luck",
	CurrentValue = false,
	Callback = function(Value)
		state.luck = Value
		if Value then
			threads.luck = task.spawn(function()
				while state.luck do
					events.upgrade:FireServer("Luck Multiplier")
					task.wait(0.5)
				end
			end)
		elseif threads.luck then
			task.cancel(threads.luck)
			threads.luck = nil
		end
	end
}, "UpgradeLuck")

-- 5. Upgrade Value (Cash)
local ValueToggle = Tab:CreateToggle({
	Name = "Upgrade Value (Cash)",
	CurrentValue = false,
	Callback = function(Value)
		state.value = Value
		if Value then
			threads.value = task.spawn(function()
				while state.value do
					events.upgrade:FireServer("Value Multiplier")
					task.wait(0.5)
				end
			end)
		elseif threads.value then
			task.cancel(threads.value)
			threads.value = nil
		end
	end
}, "UpgradeValue")

-- 6. AFK Safe
local AfkToggle = Tab:CreateToggle({
	Name = "AFK Safe",
	CurrentValue = false,
	Callback = function(Value)
		state.afk = Value
		events.afk:FireServer(Value)
	end
}, "AFKSafe")

-- Tab Home untuk info
Window:CreateHomeTab({
	SupportedExecutors = {"Delta", "Fluxus", "Arceus X", "Krnl", "Synapse"},
	DiscordInvite = "1234",
	Icon = 1,
})

-- ================== CLEANUP ==================
Window.Closed:Connect(function()
	for _, name in ipairs({"throw","buy","sell","luck","value"}) do
		if threads[name] then task.cancel(threads[name]) end
	end
end)

print("🚀 AliceHUB (Luna Edition) Loaded Successfully!")
