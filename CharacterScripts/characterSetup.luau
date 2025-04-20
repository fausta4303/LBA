local Players = game:GetService("Players")
local ss = game:GetService("ServerStorage")
local clientVFXmodule = require(ss.Assets.Generic.clientVFXModule)
local statusesModule = require(ss.Assets.Generic.statuses)
local statusesMod = require(ss.Assets.Generic.statusModule)

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAppearanceLoaded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid")
		hum.DisplayDistanceType = "None"
		--hum.HealthDisplayType = "AlwaysOff"
		---hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		--hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		--hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		local lg = ss.Assets.Generic.LeftGrip:Clone()
		local rg = ss.Assets.Generic.RightGrip:Clone()
		
		local leftArm = char["Left Arm"]
		local rightArm = char["Right Arm"]

		lg.LeftGrip.Part0 = leftArm
		rg.RightGrip.Part0 = rightArm

		lg.Parent = char["Left Arm"]
		rg.Parent = char["Right Arm"]
		
		char:SetAttribute("JumpCounter",1)
		--char:SetAttribute("CanAttack", true)
		char:SetAttribute("Attacking", false)
		char:SetAttribute("Blocking", false)
		char:SetAttribute("Attacking", false)
		char:SetAttribute("m1StringCounter", 0)
		char:SetAttribute("m1Cooldown", false)
		char:SetAttribute("midM1Combo", false)
		char:SetAttribute("slowed", false)
		
		hum.WalkSpeed = 16
		
		--statusesModule[char] = {}
	
		for i,v in pairs(char:GetChildren()) do
			if v:IsA("Accessory") then
				v:Destroy()
			end
		end
		
		--loop through each existing player to check if we need to show any VFX
		for i,v in Players:GetPlayers() do
			--loop through the attributes of each player
			print("CURRENTLY LOOKING AT VFX FOR " .. v.Name)
			for j, attribute in v.Character:GetAttributes() do
				--If we are visiting an attribute that is a string, we might be dealing with an attribute
				if type(attribute) == "string" then
					local getParticle = string.split(attribute, ".")
					local bodyPart = getParticle[#getParticle]
					table.remove(getParticle ,#getParticle)
					--if the table is empty after the removal, that means the attribute was not carrying VFX data
					if #getParticle == 0 then continue end
					
					--if it isn't empty, we're most likely dealing with an attribute :O!
					local vfxType = getParticle[1]
					
					if vfxType == "Particles" then
						clientVFXmodule.emitParticles(v.Character, getParticle, bodyPart)
					end
				end
				
			end
		end
	end)
end)
