local runService = game:GetService("RunService")
local speedRemote = game:GetService("ReplicatedStorage").RemoteEvents.speedHandlerEvent
local player = game:GetService("Players").LocalPlayer
local speed = {}

speed.baseSpeed = 16 


speed.modifiers = {}


function speed.addModifier(name : string, flatAdjustment : number, multiplier : number, target)
	if runService:IsClient() then
		print(speed.modifiers)
		print(name)
		print(flatAdjustment)
		print(multiplier)
		speed.modifiers[name] = {flat = flatAdjustment or 0, mult = multiplier or 1.0}
		speed.updateSpeed()
	elseif target then
		target = game:GetService("Players"):GetPlayerFromCharacter(target) or target
		if target then
			speedRemote:FireClient(target, {request = "addModifier", params = {name, flatAdjustment, multiplier}})
		end
	end
end

function speed.removeModifier(name : string, target)
	if speed.modifiers[name] then
		speed.modifiers[name] = nil
	end
	speed.updateSpeed()
	if runService:IsServer() then
		if target then
			target = game:GetService("Players"):GetPlayerFromCharacter(target) or target
			speedRemote:FireClient(target, {request = "removeModifier", params = {name}})
		end
	end
end


function speed.updateSpeed(target)
	if runService:IsClient() then
		local hum = player.Character.Humanoid
		if not hum then return end


		local totalSpeed = speed.baseSpeed
		local totalMultiplier = 1.0


		for _, mod in speed.modifiers do
			totalSpeed += mod.flat
			totalMultiplier *= mod.mult
		end


		print(totalSpeed * totalMultiplier)
		hum.WalkSpeed = totalSpeed * totalMultiplier
	end
end

return speed
