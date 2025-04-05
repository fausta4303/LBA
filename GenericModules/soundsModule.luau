local sfx = {
	ids = {
		block = '3041192327'
	}
}

function sfx.playSound(char, vfxName)
	print("PLAY " .. vfxName)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. sfx.ids[vfxName]
	sound.Volume = 1
	sound.Name = "sfx" .. char.Name .. vfxName
	sound.Parent = char
	sound:Play()
	
	task.wait(sound.TimeLength)

	if sound then
		sound:Destroy()
	end
	
	
	
end

return sfx
