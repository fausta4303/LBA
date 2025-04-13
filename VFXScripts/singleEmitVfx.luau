local module = {}
local ss = game:GetService("ServerStorage")
local rs = game:GetService("ReplicatedStorage")
local emitEvent = rs.RemoteEvents.VFX.singleEmit




module.emitParticles = function(particlePart, spawnPart)
	
	--Send the table representing the file path and the body part to all clients
	print("FIRE ALL DA CLIENTS")
	emitEvent:FireAllClients(particlePart, spawnPart) 
end





return module
