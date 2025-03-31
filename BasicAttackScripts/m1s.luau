local rayInfo = RaycastParams.new()
local runservice = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local statusesMod = require(ss.Assets.Generic.statusModule)

rayInfo.FilterType = Enum.RaycastFilterType.Exclude
rayInfo.CollisionGroup = "RayCasts"

local stunMod = require(rs.Assets.Generic.Modules.Combat.stuns)
--local statusMod = require(ss.Assets.Generic.statuses)
local module = {}

function module.simulateHitbox(cframe,size)
	--print("not made")
	local part = Instance.new("Part")
	part.Name = "Deez"
	part.Parent = workspace
	--part.
	part.Size = size
	part.CFrame = cframe
	part.CanCollide = false
	part.Anchored = true
	--print(part.Name)
	part.Material = Enum.Material.ForceField
	part.Color = Color3.new(1,0,0)
	part.Transparency = .6
	delay(0.1, function()
		if part then
			part:Destroy()
		end
	end)
end

function module.hitBehind(char, enemyChar)
	local charHumanoidRoot = char:FindFirstChild("HumanoidRootPart", true)
	local enemyHumanoidRoot = enemyChar:FindFirstChild("HumanoidRootPart", true)
	
	local charLook = charHumanoidRoot.CFrame.LookVector
	local enemyLook = enemyHumanoidRoot.CFrame.LookVector
	
	local charForward = Vector3.new(charLook.X, 0, charLook.Z).Unit
	local enemyForward = Vector3.new(enemyLook.X, 0, enemyLook.Z).Unit
	
	
	local radians = enemyForward:Dot(charHumanoidRoot.Position - enemyHumanoidRoot.Position)
	local deg = math.deg(radians)
	
	return deg > 0
end


function module.CheckAndDamage(char, chosenChar, hitboxSize, waitTime, hitboxTime)
	task.wait(waitTime)
	local ignoreList = {char.Name}
	--print("WE SINGING")
	local hitboxStart = tick()
	local connection
	connection = runservice.Heartbeat:Connect(function()
		local position = char.HumanoidRootPart.CFrame + (char.HumanoidRootPart.CFrame.LookVector * 5)
		--position = CFrame.new(position)
		local hits = workspace:GetPartBoundsInBox(position, hitboxSize)
		module.simulateHitbox(position, hitboxSize)
		--print("bro....")
		--print(hits)
		for _,v in hits do
			local vHumanoid = v.Parent:FindFirstChildOfClass("Humanoid")
			if vHumanoid then
				if table.find(ignoreList, v.Parent.Name) == nil then
					print("HIT A DUDE " .. v.Parent.Name)
					table.insert(ignoreList, v.Parent.Name)
					if vHumanoid.Parent:GetAttribute("Blocking") == true  and module.hitBehind(char, vHumanoid.Parent) and char:GetAttribute("m1StringCounter") ~= 5 then
						--print(module.hitBehind(char, vHumanoid.Parent))
						break
					elseif vHumanoid.Parent:GetAttribute("Blocking") == true  and char:GetAttribute("m1StringCounter") == 5 then
						v.Parent.Humanoid.Health -= 5
						vHumanoid.Parent:SetAttribute("Blocking", false)
						--stunMod.blockBreakStun(vHumanoid)
					else 
						v.Parent.Humanoid.Health -= 5
						--if vHumanoid.Parent:GetAttribute("Stunned") ~= true then
							--vHumanoid.Parent:SetAttribute("Stunned", true)
						--end
						--statusMod:Add("Stun", vHumanoid.Parent, 1, 2.0)
						statusesMod.Add(v.Parent, "Stun", {dur = 1.0})
					end
				end
			end
		end
		if tick() - hitboxStart >= hitboxTime then
			connection:Disconnect()
		end
	end)
	--print("WE NOT SINGING")
end

return module
