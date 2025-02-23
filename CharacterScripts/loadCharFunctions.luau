local module = {}
local InsertService = game:GetService("InsertService")

--I, nicey13, shall comment my code for READIBILITY!!!!!!!!


module.loadClothes = function (char, shirtID, pantID, skinColor)
	
	local shirt = char:FindFirstChildOfClass("Shirt")
	local pants = char:FindFirstChildOfClass("Pants")
	local head = char:FindFirstChild("Head",true)
	
	if not shirt then
		shirt = Instance.new("Shirt")
		shirt.Parent = char
	end

	if not pants then
		pants = Instance.new("Pants")
		pants.Parent = char
	end
	
	print("hey")
	print(char.Name)
	
	shirt.ShirtTemplate = shirtID 
	pants.PantsTemplate = pantID 
	
end

module.loadAccessories = function (char, accessoryTable)
	for i,v in pairs(accessoryTable) do
		local accessory = InsertService:LoadAsset(v[1]):GetChildren()[1]
		accessory.Parent = char
		
		local specialMesh = accessory:FindFirstChild("SpecialMesh", true)
		local accessoryWeld = accessory:FindFirstChild("AccessoryWeld", true)
		if v[2] ~= nil then
			specialMesh.Scale = v[2]
		end
		if v[3] ~= nil then
			accessoryWeld.C0 = accessoryWeld.C0 * v[3]
		end
		if v[4] ~= nil then
			specialMesh.Offset = v[4]
		end
	end
end

--Gives given char the attributes specified in attributeTable
module.loadAttributes = function (char, attributeTable)
	for i,v in pairs(attributeTable) do
		--attributeTable should be made up of (v[1],v[2]) pairs
		--v[1] = Attribute string name
		--v[2] = Initial Attribute value
		char:SetAttribute(v[1],v[2])
		
	end
end

module.loadBillboardGUI = function (char, bbGUITable)
	local head = char:FindFirstChild("Head", true)
	for i,v in pairs(bbGUITable) do
		local bb = v:Clone()
		bb.Parent = head
		bb.Adornee = head
	end
end

module.loadColor = function (char, skinColor)
	for i,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.Color = skinColor
		end
	end
end

module.loadGivenWeapons = function (char, weapon, cframePos, cframeRotation, arm)
	--print("heyyyyyy :P WE IN THE MODULE SCRIPT!!!!!")
	local motor = weapon:FindFirstChild("Weld")
	if arm == "L" then
		motor.Part1 = char:FindFirstChild("Left Arm", true):FindFirstChild("LeftGrip")
	elseif arm == "R" then
		--print("YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO " .. weapon.Name)
		motor.Part1 = char:FindFirstChild("Right Arm", true):FindFirstChild("RightGrip")
	else
		print("PLEASE pass arm in as \"L\" for left arm or \"R\" for right arm.")
	end
	weapon.Parent = char
	weapon.Name = "Weapon"

	motor.C1 = cframePos * cframeRotation
end

return module
