local InsertService = game:GetService("InsertService")
local ss = game:GetService("ServerStorage")
local loadCharFunctions = require(ss.Assets.Generic.loadCharFunctions)
local characterData = require(ss.Assets.Generic.characterData)
--local wRyoshuData = characterData.wRyoshuData

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAppearanceLoaded:Connect(function(char)
		if player:GetAttribute("Character") == nil then
			player:SetAttribute("Character","baseHeathcliff")
		end
		
		--Make sure that the attribute value concatted with "Data" matches the corresponding table name in the module!!!
		local charData = characterData[player:GetAttribute("Character") .. "Data"]
		
		loadCharFunctions.loadClothes(char, charData.shirt, charData.pants)
		loadCharFunctions.loadAccessories(char, charData.accessories)
		loadCharFunctions.loadAttributes(char, charData.attributes)
		loadCharFunctions.loadBillboardGUI(char, charData.bbGUIs)
		loadCharFunctions.loadColor(char, charData.color)
		
		if charData.rightWeapon ~= nil then
			loadCharFunctions.loadGivenWeapons(char, charData.rightWeapon[1]:Clone(), charData.rightWeaponCFrames[1], charData.rightWeaponCFrames[2], charData.rightWeapon[1]:GetAttribute("LR"))
			--[[local rWeapon = charData.rightWeapon[1]
			local motor = rWeapon:FindFirstChild("Motor6D")
			motor.Part1 = char:FindFirstChild("Right Arm", true):FindFirstChild("RightGrip")
			rWeapon.Parent = char
			
			local wRyoCframe = CFrame.new(0,-0.5,0.2)
			motor.C1 = wRyoCframe * CFrame.Angles(math.rad(30),math.rad(-90),0)
			--motor.C1 = CFrame.Angles(math.rad(30),math.rad(-90),0)]]
		end
		
		if charData.leftWeapon ~= nil then
			loadCharFunctions.loadGivenWeapons(char, charData.leftWeapon[1]:Clone(), charData.leftWeaponCFrames[1], charData.leftWeaponCFrames[2], charData.leftWeapon[1]:GetAttribute("LR"))
			--[[local rWeapon = charData.rightWeapon[1]
			local motor = rWeapon:FindFirstChild("Motor6D")
			motor.Part1 = char:FindFirstChild("Right Arm", true):FindFirstChild("RightGrip")
			rWeapon.Parent = char
			
			local wRyoCframe = CFrame.new(0,-0.5,0.2)
			motor.C1 = wRyoCframe * CFrame.Angles(math.rad(30),math.rad(-90),0)
			--motor.C1 = CFrame.Angles(math.rad(30),math.rad(-90),0)]]
		end

	end)
end)


--local humanoid = char:WaitForChild("Humanoid")
--local head = char:WaitForChild("Head")

		--[[
		if not shirt then
			shirt = Instance.new("Shirt")
			shirt.Parent = char
		end
		
		if not pants then
			pants = Instance.new("Pants")
			pants.Parent = char
		end
		]]

		--[[
		local chargeGUI = ss.Assets.WCorp.chargeBillboard:Clone()
		chargeGUI.Parent = head
		chargeGUI.Adornee = head
		]]

--InsertService:LoadAsset(15081544353):GetChildren()[1].Parent = char
