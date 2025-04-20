local ss = game:GetService("ServerStorage")
local rs = game:GetService("ReplicatedStorage")
local chargeMod = require(ss.Assets.Generic.Misc.Charge)
local animMod = require(rs.Assets.Generic.Modules.animationHandler)
local m1Mod = require(rs.Assets.Generic.Modules.Combat.m1s)

--anims
local s1Anim = rs.Animations.Skills.wDonS1
local s3Anim = rs.Animations.Skills.wDonS3

local module = {}


module.SkillOne = function(char)
	char:SetAttribute("Attacking", true)
	print("USE SKILL ONE")
	chargeMod.AddCharge(char, 5)
	--char:
	local rp = char:FindFirstChild("HumanoidRootPart", true)
	local lookVec = rp.CFrame.LookVector
	print(lookVec)
	animMod.playAnim(char, s1Anim, "s1")
	--(char, chosenChar, hitboxSize, waitTime, hitboxTime)
	m1Mod.getCharsInBox(char, char.Parent:GetAttribute("Character"), Vector3.new(5,5,10), 6/60, 0.2)
	char:SetAttribute("Attacking", false)
end

module.SkillThree = function(char)
	char:SetAttribute("Attacking", true)
	print("SKILL THREE")
	local charge = char:GetAttribute("Charge")
	local framesTillHit = 13/30 --13 frames into 30 seconds anim
	local endLag = 7/30 -- 7 second endLag
	
	animMod.playAnim(char, s3Anim, "s3")
	task.wait(framesTillHit)
	local dmgMult = 1
	if charge == 10 then 
		print("RIP SPACE!!!!!!")
		dmgMult = 2
		chargeMod.RemoveCharge(char, 10)
	else 
		print("Weaker Rip Space :(")
		char:FindFirstChild("Humanoid"):TakeDamage(20)
	end
	
	task.wait(endLag)
	char:SetAttribute("Attacking", false)
end

return module
