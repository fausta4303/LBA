local module = {}
local rs = game:GetService("ReplicatedStorage")
local vfxModule = require(rs.Assets.Generic.Modules.clientVFXModule)
local vfxEvent = rs.RemoteEvents.VFX.vfxEvent

--[character]Data, put any variables you'd need in here
module.wRyoshuData = {
	SlashTimer = .3, -- Dark Slash FadeTime
	FadeTime = .13, -- Neon Clouds Fadetime
	FadeTime2 = .09,
	SmokeTime = .3 + .15, -- Smoke Slash Fadetime (slashTimer + SmokeTime)
	MoveTime = .2, -- End of Rotation Movement for the Slash
}

--slashMesh = mesh of the slash to be played
--slashes = array of "sub-slashes" to be played, put tween data in here.
--m1Orientations = starting rotations of each slash. 1 for each m1 of a combo string
--m1Rotations = tween rotations of each slash.
module.wRyoshuSlashes = {
	
	slashMesh = rs.Assets.Mesh.RipSpaceSlash,
	
	slashes = {
		DarkSlash = {module.wRyoshuData.SlashTimer, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, {{"Transparency", 1}}},
		GlowSlash1 = {module.wRyoshuData.FadeTime, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, true, {{"Transparency", -50}}},
		GlowSlash2 = {module.wRyoshuData.FadeTime2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, true,  {{"Transparency", -100}}},
		Lightning1 = {module.wRyoshuData.FadeTime, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, true, {{"Transparency", 0}}},
		Lightning2 = {module.wRyoshuData.FadeTime, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, true, {{"Transparency", 0}}},
		Rotator = {module.wRyoshuData.MoveTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {{"CFrame", {0, 0, 0}}}}
	},
	
	m1Orientations = {
		{0,90,-15},  --{0,180,-15},
		{0,270,-200},--{0,180,-200},
		{5,160,-15},
		{15, 180, -180},
		{-60, 0, 90}--{0,180,250}
	},
	
	m1Rotations = {
		{0, math.rad(-70), 0},
		{0, math.rad(70), 0},
		{0, math.rad(-70), 0},
		{0, math.rad(70), 0},
		{math.rad(70), 0, 0}
	}
	
	
}

module.PlaySlashes = function(char, selectedCharacter, currentM1)
	print("WORKS!")
	local charSlashName = selectedCharacter .. "Slashes"
	print(charSlashName)
	local charSlashes = module[charSlashName]
	if charSlashes then
		print(charSlashes.m1Rotations[currentM1])
		local slashParams = vfxModule.CreateEffectArguments("Slash", char:WaitForChild("HumanoidRootPart"), charSlashes.slashMesh, charSlashes.slashes, charSlashes.m1Orientations[currentM1], charSlashes.m1Rotations[currentM1])
		print(slashParams)
		vfxEvent:FireAllClients(slashParams)
	end
end

return module
