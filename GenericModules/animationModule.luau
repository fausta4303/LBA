local rs = game:GetService("ReplicatedStorage")

local animHandler = {}

function animHandler.isPlaying(char, name)
	
	local anim = nil
	local charAnimator = char:FindFirstChild("Animator", true)
	for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		if v.Name == name then
			anim = v
		end
	end
	
	return (anim ~= nil)
	
end

function animHandler.playAnim(char, anim, name)
	
	local oldAnim = nil
	local charAnimator = char:FindFirstChild("Animator", true)
	for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		if v.Name == name then
			oldAnim = v
		end
	end

	if oldAnim ~= nil then oldAnim:Stop() end

	local newAnim = charAnimator:LoadAnimation(anim)
	newAnim.Name = name
	newAnim:Play()

end

function animHandler.endAnim(char, name)
	
	local animToStop = nil
	local charAnimator = char:FindFirstChild("Animator", true)
	for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		if v.Name == name then
			animToStop = v
		end
	end

	if animToStop ~= nil then animToStop:Stop() end
end

function animHandler.endAllAnims(char)
	local charAnimator = char:FindFirstChild("Animator", true)
	for i,v in pairs(charAnimator:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

return animHandler
