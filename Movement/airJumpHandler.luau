local rs = game:GetService("ReplicatedStorage")
local event = rs:FindFirstChild("airJumpEvent", true)


event.OnServerEvent:Connect(function(player, addOrRemove)
	local char = player.Character
	if addOrRemove == "add" then
		char:SetAttribute("JumpCounter", 1)
	elseif addOrRemove == "remove" then
		char:SetAttribute("JumpCounter",0)
	end
end)