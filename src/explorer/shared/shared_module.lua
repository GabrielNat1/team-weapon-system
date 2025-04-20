local Shared = {}

function Shared.GiveTools(toolsTable, backpack)
	for _, tool in pairs(toolsTable) do
		local clonedTool = tool:Clone()
		clonedTool.Parent = backpack
	end
end

function Shared.IsMobile(player)
	local platformValue = player:FindFirstChild("UserInputPlatform")
	return platformValue and platformValue.Value == "Mobile"
end

function Shared.GetTeamName(player)
	return player.Team and player.Team.Name or "Unknown"
end

return Shared
