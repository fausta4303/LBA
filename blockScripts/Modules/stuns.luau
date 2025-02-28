local module = {}
local rs = game:GetService("ReplicatedStorage")

module.blockBreakStun = function(char)
	--print("BLOCK BROKEN GRAHHHH")
	local charAnimator = char:FindFirstChild("Animator", true)
	--for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		--if v.Name == "" then
			--oldAnim = v
		--end
	--end

	local broken = rs.Animations.Stuns.blockBroken
	local block = charAnimator:LoadAnimation(broken)
	block.Name = "blockBroken"
	block:Play()
end

return module