local rayInfo = RaycastParams.new()
local runservice = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local statusesMod = require(ss.Assets.Generic.statusModule)
local knockbackMod = require(rs.Assets.Generic.Modules.Combat.knockBackModule)
local soundMod = require(ss.Assets.Generic.sfxModule)
local partMod = require(ss.Assets.Generic.newVFXMod)

--hit vfx
local hitParticles = rs.Assets.Particles.Hits.HitVFX

--blockbreak vfx
local staggerPaticles = rs.Assets.Particles.Hits.StaggeredVFX

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
	
	return deg < 0
end

--target == CHAR to Damage humanoid of 
--currentM1Counter == the current m1 in the cycle of attacker
function module.normalHit(attackerChar, targetChar, targetHum, currentM1Counter, dmg)
	if(attackerChar:GetAttribute("Stun")) then return end
	targetHum:TakeDamage(dmg)
	statusesMod.Add(targetChar, "Stun", {dur = 1.0})
	if currentM1Counter == 5 then 
		knockbackMod.apply(attackerChar, targetChar) 
	end
	partMod.emitParticles(hitParticles, targetChar:FindFirstChild("HumanoidRootPart"))
end

function module.blockBreak(attackerChar, targetChar, targetHum, currentM1Counter, dmg)
	if(attackerChar:GetAttribute("Stun")) then return end
	local rootpart = targetChar:FindFirstChild("HumanoidRootPart")
	targetHum:TakeDamage(dmg)
	targetChar:SetAttribute("Blocking", false)
	statusesMod.Add(targetChar, "Stun", {dur = 5.0})
	print("PLAY VFX")
	partMod.emitParticles(staggerPaticles, rootpart)
	soundMod.playSound(targetChar, 'stagger')
end


function module.CheckAndDamage(char, chosenChar, hitboxSize, waitTime, hitboxTime)
	task.wait(waitTime)
	local ignoreList = {char.Name}
	--print("WE SINGING")
	local hitboxStart = tick()
	local connection
	connection = runservice.Heartbeat:Connect(function()
		if(char:GetAttribute("Stun")) then connection:Disconnect() end
		local position = char.HumanoidRootPart.CFrame + (char.HumanoidRootPart.CFrame.LookVector * 5)
		--position = CFrame.new(position)
		local hits = workspace:GetPartBoundsInBox(position, hitboxSize)
		--module.simulateHitbox(position, hitboxSize)
		--print("bro....")
		--print(hits)
		for _,v in hits do
			local vHumanoid = v.Parent:FindFirstChildOfClass("Humanoid")
			if vHumanoid then
				if table.find(ignoreList, v.Parent.Name) == nil then
					--print("HIT A DUDE " .. v.Parent.Name)
					table.insert(ignoreList, v.Parent.Name)
				
					local currM1 = char:GetAttribute("m1StringCounter")
					
					if module.hitBehind(char, vHumanoid.Parent) or not vHumanoid.Parent:GetAttribute("Blocking") then

						--print(module.hitBehind(char, vHumanoid.Parent))
						--print(vHumanoid.Parent:GetAttribute("Blocking"))
						module.normalHit(char, vHumanoid.Parent, vHumanoid, currM1, 5)
						
					elseif vHumanoid.Parent:GetAttribute("Blocking") then
						if currM1 == 5 then
							--print("BREAK BLOCK HERE")
							module.blockBreak(char, vHumanoid.Parent, vHumanoid, currM1, 5)
						else
							--print("DONT DMG")
							soundMod.playSound(vHumanoid.Parent, 'block')
						end
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




function module.getCharsInBox(char, chosenChar, hitboxSize, waitTime, hitboxTime)
	task.wait(waitTime)
	local ignoreList = {char.Name}
	local hitPlayers = {}
	--print("WE SINGING")
	--local hitboxStart = tick()
	if(char:GetAttribute("Stun")) then return end
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
					--print("HIT A DUDE " .. v.Parent.Name)
					table.insert(ignoreList, v.Parent.Name)

					table.insert(hitPlayers, v)
					
				end
			end
		end
		
	return hitPlayers
	--print("WE NOT SINGING")
end

return module
