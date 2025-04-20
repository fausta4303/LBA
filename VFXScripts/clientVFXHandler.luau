local ss = game:GetService("ServerStorage")
local rs = game:GetService("ReplicatedStorage")
local emitParticlesEvent = rs.RemoteEvents.emitParticlesEvent
local deleteParticlesEvent = rs.RemoteEvents.deleteParticlesEvent


local function applyParticles(vfx, bodyPart)
	
	--if it's a real particle
	if vfx:IsA("ParticleEmitter") then
		--if the particle is meant to be permanent (is particle.Rate is 0, it's a temporary emmission! :O)
		if (vfx.Enabled == true and vfx.Rate ~= 0) or (vfx.Enabled == false and vfx.Rate ~= 0) then
			if vfx.Parent == nil then vfx.Parent = bodyPart end
			vfx.Enabled = true
		
		--if the particle is a temporary emmission
		else
			local emitCount = vfx:GetAttribute("EmitCount")
			local emitDelay = vfx:GetAttribute("EmitDelay")
			print()
			task.spawn(function()
				task.wait(emitDelay)
				if vfx.Parent == nil then vfx.Parent = bodyPart end
				vfx:Emit(emitCount)
			end)
		end
	
	--As of now this case is just for PointLight's. If we need more functionality later I will add
	else
		if vfx.Parent == nil then vfx.Parent = bodyPart end
		vfx.Enabled = true
	end
end


emitParticlesEvent.OnClientEvent:Connect(function(particlePath, bodyPart)
	local currentParent = rs.Assets
	local ppSize = #particlePath
	
	
	for i = 1, ppSize do
		currentParent = currentParent:FindFirstChild(particlePath[i])
	end
	
	local newParticles = currentParent:Clone()
	
	--if singular particle
	if newParticles:IsA("ParticleEmitter") == true then
		--print(newParticles.Name)
		--print(bodyPart.Name)
		applyParticles(newParticles, bodyPart)
	
	--if multiple
	else
		newParticles.Parent = bodyPart
		newParticles.Weld.Part1 = bodyPart
		for i,v in newParticles.Attachment:GetChildren() do
			applyParticles(v, bodyPart)
		end
	end
end)

deleteParticlesEvent.OnClientEvent:Connect(function(particleName, bodyPart)
	bodyPart:FindFirstChild(particleName):Destroy()
	
	--print("The two: " .. bodyPart .. "AND" .. particleName)
end)