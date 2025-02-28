local ss = game:GetService("ReplicatedStorage")
--local stunMod = require(ss.Assets.Generic.Modules.Combat.stuns)
local module = {}

function module.handleBlock(char, chosenChar)
	print("INITIATE BLOCK YEAHHHHHHH")
	--local pmoonCharData = "a"--characterDataModule[chosenChar]
	
	local oldAnim = nil
	--animation handling stuff
	local charAnimator = char:FindFirstChild("Animator", true)
	for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		if v.Name == "block" then
			oldAnim = v
		end
	end
	
	local pmoonCharBlock = chosenChar.blockAnim
	local block = charAnimator:LoadAnimation(pmoonCharBlock)
	block.Name = "block"
	block:Play()
	char:SetAttribute("Blocking", true)
	--block:Stop()
	--if oldAnim ~= nil then oldAnim:Stop() end
end

function module.endBlock(char)
	char:SetAttribute("Blocking", false)
	local charAnimator = char:FindFirstChild("Animator", true)
	for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		if v.Name == "block" then
			v:Stop()
		end
	end
end

return module
