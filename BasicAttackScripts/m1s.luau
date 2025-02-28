local rayInfo = RaycastParams.new()
local runservice = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
rayInfo.FilterType = Enum.RaycastFilterType.Exclude
rayInfo.CollisionGroup = "RayCasts"
local stunMod = require(rs.Assets.Generic.Modules.Combat.stuns)
local module = {}

function module.simulateHitbox(cframe,size)
	print("not made")
	local part = Instance.new("Part")
	part.Name = "Deez"
	part.Parent = workspace
	--part.
	part.Size = size
	part.CFrame = cframe
	part.CanCollide = false
	part.Anchored = true
	print(part.Name)
	part.Material = Enum.Material.ForceField
	part.Color = Color3.new(1,0,0)
	part.Transparency = .6
	delay(0.1, function()
		if part then
			part:Destroy()
		end
	end)
end


function module.CheckAndDamage(char, chosenChar, hitboxSize, waitTime, hitboxTime)
	task.wait(waitTime)
	local ignoreList = {char.Name}
	print("WE SINGING")
	local hitboxStart = tick()
	local connection
	connection = runservice.Heartbeat:Connect(function()
		local position = char.HumanoidRootPart.CFrame + (char.HumanoidRootPart.CFrame.LookVector * 5)
		--position = CFrame.new(position)
		local hits = workspace:GetPartBoundsInBox(position, hitboxSize)
		module.simulateHitbox(position, hitboxSize)
		print("bro....")
		--print(hits)
		for _,v in hits do
			local vHumanoid = v.Parent:FindFirstChildOfClass("Humanoid")
			if vHumanoid then
				if table.find(ignoreList, v.Parent.Name) == nil then
					print("HIT A DUDE " .. v.Parent.Name)
					table.insert(ignoreList, v.Parent.Name)
					if vHumanoid.Parent:GetAttribute("Blocking") == true  and char:GetAttribute("m1StringCounter") ~= 5 then
						break
					elseif vHumanoid.Parent:GetAttribute("Blocking") == true  and char:GetAttribute("m1StringCounter") == 5 then
						v.Parent.Humanoid.Health -= 5
						vHumanoid.Parent:SetAttribute("Blocking", false)
						stunMod.blockBreakStun(vHumanoid)
					else 
						v.Parent.Humanoid.Health -= 5
					end
				end
			end
		end
		if tick() - hitboxStart >= hitboxTime then
			connection:Disconnect()
		end
	end)
	print("WE NOT SINGING")
end

return module
