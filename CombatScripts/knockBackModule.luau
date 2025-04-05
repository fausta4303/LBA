local tweenService = game:GetService("TweenService")
local knockBack = {}

function knockBack.apply(char, target)
	print("KNOCKBACK GRAH")
	local charHumanoidRoot = char:FindFirstChild("HumanoidRootPart", true)
	local targetHumanoidRoot = target:FindFirstChild("HumanoidRootPart", true)
	local dir = (targetHumanoidRoot.Position - charHumanoidRoot.Position).Unit

	local charLook = charHumanoidRoot.CFrame.LookVector

	local charForward = Vector3.new(charLook.X, 0, charLook.Z).Unit
	
	local knockbackVel = Instance.new("BodyVelocity")
	knockbackVel.Name = "KnockBack"
	knockbackVel.Parent = targetHumanoidRoot
	knockbackVel.MaxForce = Vector3.new(500000, 500000, 500000) * 10
	knockbackVel.P = 10
	
	knockbackVel.Velocity = Vector3.new(charForward.x, 1, charForward.z) * 50
	
	local knockTween = tweenService:Create(knockbackVel, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {MaxForce = Vector3.zero})
	knockTween:Play()
	
	knockTween.Completed:Connect(function()
		knockbackVel:Destroy()
	end)
	
	
end

return knockBack
