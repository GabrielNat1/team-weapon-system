local remote = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GetPlatform")
local inputType = game:GetService("UserInputService").TouchEnabled and "Mobile" or "PC"

local val = Instance.new("StringValue")
val.Name = "UserInputPlatform"
val.Value = inputType
val.Parent = game.Players.LocalPlayer

remote:InvokeServer()
