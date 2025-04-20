local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local characterDataModule = require(ss.Assets.Generic.characterData)
local loadCharFunctions = require(ss.Assets.Generic.loadCharFunctions)
local clientVFXFunctions = require(ss.Assets.Generic.clientVFXModule)
local chargeParticleEvent = rs:FindFirstChild("chargeParticleEvent", true)

local function onParticleEffectRequested(player, charge)
	local currentCharacter = player:GetAttribute("Character")
	local charData = characterDataModule[currentCharacter .. "Data"]
	local character = player.Character
	print(player.Name .. " " .. " " .. tostring(charge))
	
	--Find head and change billboard for all players
	local head = character:FindFirstChild("Head", true)
	local billboard = head:FindFirstChild("chargeBillboard", true)
	print("current charge: " .. tostring(charge))
	billboard.Frame.TextLabel.Text = tostring(charge)
	
	--Find the weapon model attached to the player
	local weapon = character:FindFirstChild("Weapon")
	--clientVFXFunctions.emitParticles(character, {"Particles","Charge","ChargeTier2"}, "Head")
	--print("Hello bruh " .. weapon.Name)
	
	if character and character:IsA("Model") and character:FindFirstChild("Humanoid") then
		
		if charge < 5 then
			if character:GetAttribute("ChargeTier1") ~= nil then clientVFXFunctions.deleteParticles(character, character:GetAttribute("ChargeTier1")) end
			if character:GetAttribute("ChargeTier2") ~= nil then clientVFXFunctions.deleteParticles(character, character:GetAttribute("ChargeTier2")) end
			if character:GetAttribute("ChargeUpgrade") ~= nil then clientVFXFunctions.deleteParticles(character, character:GetAttribute("ChargeUpgrade")) end
			
			if #charData.rightWeapon >= 1 then
				local weaponArm = weapon:GetAttribute("LR")
				weapon:Destroy()
				loadCharFunctions.loadGivenWeapons(character, charData.rightWeapon[1]:Clone(), charData.rightWeaponCFrames[1], charData.rightWeaponCFrames[2], weaponArm)
			end
			
		elseif charge >= 5 and charge < 10 then
			clientVFXFunctions.emitParticles(character, {"Particles","Charge","ChargeTier1"}, "Right Arm")
			
			if character:GetAttribute("ChargeTier2") ~= nil then clientVFXFunctions.deleteParticles(character, character:GetAttribute("ChargeTier2")) end
			if character:GetAttribute("ChargeUpgrade") ~= nil then clientVFXFunctions.deleteParticles(character, character:GetAttribute("ChargeUpgrade")) end
			
			if #charData.rightWeapon >= 2 then
				local weaponArm = weapon:GetAttribute("LR")
				weapon:Destroy()
				loadCharFunctions.loadGivenWeapons(character, charData.rightWeapon[2]:Clone(), charData.rightWeaponCFrames[1], charData.rightWeaponCFrames[2], weaponArm)
			end
			
		elseif charge == 10 then
			clientVFXFunctions.emitParticles(character, {"Particles","Charge","ChargeTier2"}, "Right Arm")
			clientVFXFunctions.emitParticles(character, {"Particles","Charge","ChargeUpgrade"}, "Right Arm")
			
			if character:GetAttribute("ChargeTier1") ~= nil then clientVFXFunctions.deleteParticles(character, character:GetAttribute("ChargeTier1")) end
			
			if #charData.rightWeapon >= 3 then
				local weaponArm = weapon:GetAttribute("LR")
				weapon:Destroy()
				loadCharFunctions.loadGivenWeapons(character, charData.rightWeapon[3]:Clone(), charData.rightWeaponCFrames[1], charData.rightWeaponCFrames[2], weaponArm)
			end
		end
	end
end

chargeParticleEvent.OnServerEvent:Connect(onParticleEffectRequested)
