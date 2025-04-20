--[[

 ██████╗ ███████╗████████╗███████╗██████╗ ███████╗███████╗████████╗
██╔════╝ ██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝
██║  ███╗█████╗     ██║   █████╗  ██████╔╝█████╗  █████╗     ██║   
██║   ██║██╔══╝     ██║   ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══╝     ██║   
╚██████╔╝███████╗   ██║   ███████╗██║     ███████╗███████╗   ██║   
 ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚══════╝╚══════╝   ╚═╝   


📦 Weapon Distribution System with Platform Check (Mobile/PC)
👨‍💻 Developed by: stevetroll

📌 Description:
This script detects the player's platform (PC or Mobile) as soon as they enter the game.
Based on that, it automatically gives them an appropriate weapon set:

📱 Mobile players receive specific weapons:
    - AK47
    - Pistol
    - SMG
    - Shotgun

💻 PC players receive weapons based on their team.

⚙️ Dependency:
Requires the "shared_module" for auxiliary functions.
]]


local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Shared = require(script.Parent.Parent.shared.shared_module)

-- Folder where weapon models are stored in ServerStorage
local modelsFolder = ServerStorage:WaitForChild("Models")

-- General weapons (used for PC players)
local weapons = {
	fal = modelsFolder:WaitForChild("M4 Carbine"),
	glock = modelsFolder:WaitForChild("G17"),
	m870 = modelsFolder:WaitForChild("M870"),
	AmmoGiver = modelsFolder:WaitForChild("AmmoGiver"),
	Prancheta = modelsFolder:WaitForChild("Prancheta")
}

-- Weapons exclusive for Mobile players
local mobileWeapons = {
	modelsFolder.Mobile:WaitForChild("AK47"),
	modelsFolder.Mobile:WaitForChild("Pistol"),
	modelsFolder.Mobile:WaitForChild("SMG"),
	modelsFolder.Mobile:WaitForChild("Shotgun")
}

-- Loadouts by team (for PC players)
local teamLoadouts = {
	["Team1"] = { "glock", "Prancheta", "m870", "AmmoGiver" },
	["Team2"] = {},
	["Team3"] = { "fal", "glock", "Prancheta", "m870", "AmmoGiver" },
	["Team4"] = { "fal", "glock", "Prancheta", "m870", "AmmoGiver" },
	["Team5"] = { "fal", "Prancheta", "m870", "AmmoGiver" },
	["Team6"] = { "fal", "glock", "Prancheta", "m870", "AmmoGiver" },
	["Team7"] = { "fal", "Prancheta", "m870", "AmmoGiver" },
	["Team8"] = { "fal", "glock", "Prancheta", "m870", "AmmoGiver" },
	["Team9"] = { "fal", "Prancheta", "m870", "AmmoGiver" }
}

-- Function for equipping PC players with weapons based on their team
local function equipTeamWeapons(player)
	local loadout = teamLoadouts[Shared.GetTeamName(player)]
	if not loadout then return end

	local backpack = player:WaitForChild("Backpack")
	local toolsToGive = {}

	for _, weaponName in ipairs(loadout) do
		local weapon = weapons[weaponName]
		if weapon then
			table.insert(toolsToGive, weapon)
		end
	end

	Shared.GiveTools(toolsToGive, backpack)
end

-- Detect platform and distribute weapons accordingly
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local remote = Instance.new("RemoteFunction")
		remote.Name = "GetPlatform"
		remote.Parent = player:WaitForChild("PlayerGui")

		local platformValue = Instance.new("StringValue")
		platformValue.Name = "UserInputPlatform"
		platformValue.Value = "Unknown"
		platformValue.Parent = player

		remote.OnServerInvoke = function(plr)
			return Shared.IsMobile(plr)
		end

		task.wait(1)

		-- Check if the player is on mobile or PC and give appropriate weapons
		if Shared.IsMobile(player) then
			Shared.GiveTools(mobileWeapons, player:WaitForChild("Backpack"))
		else
			equipTeamWeapons(player)
		end
	end)
end)



