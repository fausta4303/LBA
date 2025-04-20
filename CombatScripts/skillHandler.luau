local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local skillOneEvent = rs.RemoteEvents.Skills.skillOneEvent
local skillTwoEvent = rs.RemoteEvents.Skills.skillTwoEvent
local skillThreeEvent = rs.RemoteEvents.Skills.skillThreeEvent
local actionMod = require(rs.Assets.Generic.Modules.actionsModule)

local skillsFolder = ss.Assets.Generic.Skills:GetChildren()
local skills = {}

for i,v in skillsFolder do
	skills[v.Name] = require(v)
	print("LOADED A SCRIPT YEYEYEYEYEYEYYEEYEYEYEYEYE")
end

function skillOne(player, char)
	if not actionMod.check("attack", char) then return end
	print(char)
	local pmoonChar = player:GetAttribute("Character")
	if skills[pmoonChar] then skills[pmoonChar].SkillOne(char) end
end

function skillTwo(player, char)
	if not actionMod.check("attack", char) then return end
	print(char)
	local pmoonChar = player:GetAttribute("Character")
	if skills[pmoonChar] then skills[pmoonChar].SkillTwo(char) end
end

function skillThree(player, char)
	if not actionMod.check("attack", char) then return end
	print(char)
	local pmoonChar = player:GetAttribute("Character")
	if skills[pmoonChar] then skills[pmoonChar].SkillThree(char) end
end

skillOneEvent.OnServerEvent:Connect(skillOne)
skillOneEvent.OnServerEvent:Connect(skillTwo)
skillThreeEvent.OnServerEvent:Connect(skillThree)