print("OVA HERE")
local player = game.Players.LocalPlayer
local inputService = game:GetService("UserInputService")
local rs = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local char = player.Character
local hum = player.Character:FindFirstChild("Humanoid", true)
local charAnimator = char:FindFirstChild("Animator", true)

local mouseLockController = player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
local event = rs:FindFirstChild("airJumpEvent", true)
local m1Event = rs.RemoteEvents.m1Event
local blockEvent = rs.RemoteEvents.blockEvent
local unblockEvent = rs.RemoteEvents.unblockEvent
local jumpingAnim = charAnimator:LoadAnimation(rs.Animations.airJump)
local blockBuffering = false

--here be the dash variables
local dashDirections = {
	--Multiple key cases YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAY!!!!!!!!!!
	{Enum.KeyCode.S, "bothVectors", -1, 1, Enum.KeyCode.D, Enum.KeyCode.A},
	{Enum.KeyCode.S, "bothVectors", -1, -1, Enum.KeyCode.A, Enum.KeyCode.D},
	{Enum.KeyCode.W,"bothVectors", 1, 1, Enum.KeyCode.D, Enum.KeyCode.A},
	{Enum.KeyCode.W, "bothVectors", 1, -1, Enum.KeyCode.A, Enum.KeyCode.D},
	
	{Enum.KeyCode.S, "lookVector", -1, Enum.KeyCode.W},
	{Enum.KeyCode.A, "rightVector", -1, Enum.KeyCode.D},
	{Enum.KeyCode.D,"rightVector", 1, Enum.KeyCode.A},
	{Enum.KeyCode.W, "lookVector", 1, Enum.KeyCode.S},
}
local dashDebounce = false
local dashCD = 1.5

local runningSpeed = 24
local slowSpeed = 16
local runningAnim = charAnimator:LoadAnimation(rs.Animations.basicRunning)
local rotationTween = nil
local isMoving = false

--Set for each individual player, so as to not mess with projectiles :D!!!!!!!!!!!!!!!!!!!!!! YIPPIE
game.Workspace.Gravity = 100

--Rebinds shiftlock to LeftControl
local boundKeys = mouseLockController:FindFirstChild("BoundKeys")
if boundKeys then
	boundKeys.Value = "LeftControl"
else
	boundKeys = Instance.new("StringValue")
	boundKeys.Name = "BoundKeys"
	boundKeys.Value = "LeftControl"
	boundKeys.Parent = mouseLockController
end

--Functions below
local function onStateChange(oldState, newState)
	if oldState == Enum.HumanoidStateType.Freefall and newState == (Enum.HumanoidStateType.Landed or Enum.HumanoidStateType.Running) then
		event:FireServer("add")
	end
end

--local function isKeyHeld(keyCode)
--	return keyHeld[keyCode] or false
--end

local function initiateDash(vectorType, posOrNeg, posOrNeg2ndVector)
	if dashDebounce == true then
		return
	end
	dashDebounce = true
	
	local cam = workspace.CurrentCamera
	local bodyVel = Instance.new("BodyVelocity")
	local force = 50 --old "ABA" like value is 45
	--local loopIterations = 20
	local dashDuration = 0.2
	bodyVel.Parent = char.HumanoidRootPart
	bodyVel.MaxForce = Vector3.new(500000, 0, 500000)
	bodyVel.P = 10
	
	if vectorType == "lookVector" then
		local dashStart = tick()
		runservice:BindToRenderStep("dashStep", 1, function()
			local lookVector = cam.CFrame.LookVector
			local upVector = cam.CFrame.UpVector
			local lookVectorX = lookVector.X
			local lookVectorZ = lookVector.Z
			if (lookVectorX == lookVectorZ) and ((lookVectorX == 0) or (lookVectorX == 1)) then
				lookVectorX = upVector.X
				lookVectorZ = upVector.Z
			end
			local forwardVector = Vector3.new(lookVectorX, 0, lookVectorZ).Unit
			bodyVel.Velocity = Vector3.new(forwardVector.X, 0, forwardVector.Z) * force * posOrNeg
			
			if tick() - dashStart >= dashDuration then
				bodyVel:Destroy()
				runservice:UnbindFromRenderStep("dashStep")
			end
		end)
	
	elseif vectorType == "rightVector" then
		
		--for turning 2.0
		local dashStart = tick()
		runservice:BindToRenderStep("dashStep", 1, function()
			
			bodyVel.Velocity = cam.CFrame.rightVector * force * posOrNeg
			bodyVel.Velocity = Vector3.new(bodyVel.Velocity.X, 0, bodyVel.Velocity.Z)
			
			if tick() - dashStart >= dashDuration then
				bodyVel:Destroy()
				runservice:UnbindFromRenderStep("dashStep")
			end
		end)
	
	elseif vectorType == "bothVectors" then
		local dashStart = tick()
		runservice:BindToRenderStep("dashStep", 1, function()
			
			--lookVector finding
			local lookVector = cam.CFrame.LookVector
			local upVector = cam.CFrame.UpVector
			local lookVectorX = lookVector.X
			local lookVectorZ = lookVector.Z
			if (lookVectorX == lookVectorZ) and ((lookVectorX == 0) or (lookVectorX == 1)) then
				lookVectorX = upVector.X
				lookVectorZ = upVector.Z
			end

			--set up el forwardVector using lookVector and get the rightVector
			local forwardVector = Vector3.new(lookVectorX, 0, lookVectorZ).Unit * posOrNeg
			local rightVector = cam.CFrame.rightVector * posOrNeg2ndVector
			
			--combine them :D boom diagonal dash
			bodyVel.Velocity = (forwardVector + rightVector).Unit * force
			bodyVel.Velocity = Vector3.new(bodyVel.Velocity.X, 0, bodyVel.Velocity.Z)

			if tick() - dashStart >= dashDuration then
				bodyVel:Destroy()
				runservice:UnbindFromRenderStep("dashStep")
			end
		end)
	end

	--task.wait(0.3)
	
	task.wait(dashCD)
	dashDebounce = false
	
end



local function sprintHandling()
	repeat
		task.wait()
		local moveDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)
		if moveDir.Magnitude > 0 then
			--If we're currently not attacking or blocking, sprint as normal
			if char:GetAttribute("CanAttack") == true and (char:GetAttribute("Blocking") == false or char:GetAttribute("Blocking") == nil) then
			
				
				if hum.WalkSpeed ~= runningSpeed then hum.WalkSpeed = runningSpeed end
				
				if char:GetAttribute("midM1Combo") == false then
					if hum.AutoRotate == true then hum.AutoRotate = false end
					if not runningAnim.IsPlaying then 
						runningAnim:Play()
						runningAnim.Name = "basicRun"
					end
				end
				

				local newCFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + moveDir)
				rotationTween = tweenService:Create(char.HumanoidRootPart, TweenInfo.new(0.1), {CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + moveDir)})
				rotationTween:Play()
				--We're currently attacking, slow down
			else
				
				
				if hum.WalkSpeed ~= slowSpeed then hum.WalkSpeed = slowSpeed end
				if hum.AutoRotate == false then hum.AutoRotate = true end
				if runningAnim.IsPlaying then runningAnim:Stop() end
				if rotationTween ~= nil then rotationTween:Cancel() end
			end

			--If we're not moving/idle
		else 
			isMoving = false
		end
	until isMoving == false
	
	if runningAnim.IsPlaying then
		runningAnim:Stop()
	end
	if rotationTween ~= nil then
		rotationTween:Cancel()
	end
end




--Input Detection begins here
inputService.InputBegan:Connect(function(input, GPE)
	if char:GetAttribute("Stunned") == false or char:GetAttribute("Stunned") == nil then
		if isMoving == false and (input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.S) then
			isMoving = true
			sprintHandling()
		end
			
		if input.KeyCode == Enum.KeyCode.Space and char:GetAttribute("CanAttack") == true  and char:GetAttribute("slowed") == false then
			if hum.FloorMaterial == Enum.Material.Air and char:GetAttribute("JumpCounter") == 1 then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
				jumpingAnim:Play()
				jumpingAnim.Name = "airJump"
				event:FireServer("remove")
			end
			
		elseif input.KeyCode == Enum.KeyCode.Q then
			--local areKeysPressed = false
			for i in dashDirections do
				if #dashDirections[i] > 4 then
					if inputService:IsKeyDown(dashDirections[i][1]) and inputService:IsKeyDown(dashDirections[i][5]) and not inputService:IsKeyDown(dashDirections[i][6]) then
						initiateDash(dashDirections[i][2], dashDirections[i][3], dashDirections[i][4])
						--areKeysPressed = true
						break
					end
				else
					if inputService:IsKeyDown(dashDirections[i][1]) and not inputService:IsKeyDown(dashDirections[i][4]) then
						print(dashDirections[i][1])
						initiateDash(dashDirections[i][2], dashDirections[i][3], 0)
						--areKeysPressed = true
						break
					end
				end
			end
		end
	end
	
	--block logic
	if input.KeyCode == Enum.KeyCode.F then
			print("LOCALSCRIPT BLOCK")
			--blockEvent:FireServer(char)
			blockBuffering = true
			--task.spawn(function()
				--while(blockBuffering) do
					--if char:GetAttribute("Blocking") == false or char:GetAttribute("Blocking") == nil then
						--blockBuffering = true
					--end
	end
	
	
		--end)
		--[[if areKeysPressed == false then
			initiateDash("lookVector",-1)
			--char.HumanoidRootPart.BodyVelocity.Velocity = char.HumanoidRootPart.CFrame.lookVector * -200
		end]]
end)

inputService.InputEnded:Connect(function(input, GPE)
	if input.KeyCode == Enum.KeyCode.F then
		blockBuffering = false
	end
end)

--Mouse input ova here

--Left mouse button
player:GetMouse().Button1Down:Connect(function()
	if char:GetAttribute("Stunned") == false or char:GetAttribute("Stunned") == nil then
		if char:GetAttribute("CanAttack") == true and (char:GetAttribute("Blocking") == false or char:GetAttribute("Blocking") == nil) then
			if isMoving == false then
				if hum.AutoRotate == false then hum.AutoRotate = true end
			end
			m1Event:FireServer()
		end
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	
	--BLOCK HANDLING
	if blockBuffering then
		print("F is currently being held!")
		if char:GetAttribute("Blocking") ~= true and char:GetAttribute("Stunned") ~= true then
			blockEvent:FireServer(char)
		end
	elseif not blockBuffering then
		if char:GetAttribute("Blocking") == true then
			unblockEvent:FireServer(char)
		end
	end
	
	--STUN HANDLING
	if char:GetAttribute("Stunned") == true then
		hum.WalkSpeed = 2
		hum.JumpHeight = 0
	elseif char:GetAttribute("Stunned") == false or char:GetAttribute("Stunned") == nil then
		--hum.WalkSpeed = 16
		--hum.JumpPower = 50
		hum.JumpHeight = 7.2
	end
end)

hum.StateChanged:Connect(onStateChange)
--sprintHandling()



