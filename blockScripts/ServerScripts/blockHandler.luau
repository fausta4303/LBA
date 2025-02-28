local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local blockMod = require(rs.Assets.Generic.Modules.Combat.blocks)
local characterDataModule = require(ss.Assets.Generic.characterData)
local blockEvent = rs.RemoteEvents.blockEvent
local unblockEvent = rs.RemoteEvents.unblockEvent

local function initiateBlock(player)
	print("AAAAAAAAAAAAA")
	local char = player.Character
	local pmoonChar = player:GetAttribute("Character") .. "Data"
	print(pmoonChar)
	blockMod.handleBlock(char, characterDataModule[pmoonChar])
end

local function endBlock(player)
	blockMod.endBlock(player.Character)
end

blockEvent.OnServerEvent:Connect(function(player, char)
	if char:GetAttribute("Blocking") == nil then
		char:SetAttribute("Blocking",false)
	end
	if char:GetAttribute("Blocking") == false then
		initiateBlock(player)
	else
		print("END IT GRAHHHH")
		endBlock(player)
	end
end)
