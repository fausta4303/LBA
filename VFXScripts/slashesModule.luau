local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local rs = game:GetService("ReplicatedStorage")
local module = {}

--pos is the character/object we spawning the slash on
--slashMesh is the slash object
--tweenInfos is the table of tween data from the characterSlashes module
--OrientationArray is the table of starting orientations from the characterSlashes module
--RotationArray is the table of rotations to tween through from the characterSlashes module
function module.CreateSlashAndTween(pos, slashMesh, tweenInfos, OrientationArray, RotationArray)
	local object = pos
	if typeof(pos) == "Instance" then
		pos = pos.CFrame
	end
	task.wait(0.1)
	
	local slash = slashMesh:Clone()
	slash.Name = slashMesh.Name
	slash.CFrame = pos

	local PivotingPart = rs.Assets.Generic.Pivot:Clone()
	PivotingPart.Name = "PivotPart"
	PivotingPart.CFrame = slash.CFrame
	
	slash.Parent = workspace
	--slash.Orientation += Vector3.new(0, 180, 0)
	PivotingPart.Parent = workspace
	
	local motor = Instance.new("Weld")
	motor.Part0 = object -- char
	motor.Part1 = slash
	motor.Parent = object
	--motor.C1 *= CFrame.Angles(RotationArray[1], RotationArray[2], RotationArray[3])
	--PivotingPart.Orientation *= -1
	slash.Orientation += Vector3.new(OrientationArray[1], OrientationArray[2], OrientationArray[3])
	
	print("PLAY DAT SHIT")
	for i,v in pairs(slash:GetChildren()) do
		if v:IsA("Decal") then
			print(v.Name)
			print(tweenInfos[v.Name])
			print(#tweenInfos[v.Name])
			local goal = {}
			if #tweenInfos[v.Name] > 4 then
				for i,v in pairs(tweenInfos[v.Name][6]) do
					goal[v[1]] = v[2]
				end
				TweenService:Create(v, TweenInfo.new(tweenInfos[v.Name][1], tweenInfos[v.Name][2], tweenInfos[v.Name][3], tweenInfos[v.Name][4], tweenInfos[v.Name][5]), goal):Play()
			else
				for i,v in pairs(tweenInfos[v.Name][4]) do
					goal[v[1]] = v[2]
				end
				TweenService:Create(v, TweenInfo.new(tweenInfos[v.Name][1], tweenInfos[v.Name][2], tweenInfos[v.Name][3]), goal):Play()
			end
		end
	end
	
	local goal = {}
	for i,v in pairs(tweenInfos.Rotator[4]) do
		if v[1] == "CFrame" then
			print("CFRAME BABY")
			print(v[2])
			goal["C1"] = motor.C1 * CFrame.Angles(RotationArray[1], RotationArray[2], RotationArray[3])
		else
			goal[v[1]] = v[2]
		end
	end
	print(goal)
	TweenService:Create(motor, TweenInfo.new(tweenInfos.Rotator[1], tweenInfos.Rotator[2], tweenInfos.Rotator[3]), goal):Play()
	
	
end

return module
