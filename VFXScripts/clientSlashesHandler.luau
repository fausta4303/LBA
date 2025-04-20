local module = {}
local rs = game:GetService("ReplicatedStorage")
local remote = rs.RemoteEvents.VFX.vfxEvent
local slashesModule = require(rs.Assets.Generic.Modules.VFX.slashesModule)


local exampleInfoTable = {
	["Target"] = CFrame.new(0, 0, 0),
	["EffectName"] = "Mesh",
	["Mesh"] = nil,
	["Data"] = nil
	--etc more commonly used stuff
}

local darkSlashTable = {
	["Target"] = game.Players.LocalPlayer,
	["slashMesh"] = rs.Assets.Mesh.RipSpaceSlash,
	
	
}

--Create a table with the potential arguments for the remotevent. Set something as nil if it aint needed!
function module.CreateEffectArguments(EffectName, Target, Mesh, Data, Orientation, Rotation)
	print("YAAYYYYYYY!!!!")
	local argTable = table.clone(exampleInfoTable)
		argTable.EffectName = EffectName
		argTable.Target = Target
		argTable.Mesh = Mesh
		argTable.Data = Data
		argTable.Orientation = Orientation
		argTable.Rotation = Rotation
		return argTable
end

function module.SetupRemoteListener()
	if game:GetService("RunService"):IsClient() then
		remote.onClientEvent:Connect(function(arguments: typeof(vfxTable)) --the typeof enables autofill
			--run a module based on effectname etc
			print("WTH")
			if arguments.EffectName == "Slash" then
				print("BOY")
				print(arguments.EffectName)
				--print(arguments.Target.name)
				--TweenService:Create(Slash.DarkSlash, TweenInfo.new(SlashTimer, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Transparency = 1}):Play()
				slashesModule.CreateSlashAndTween(arguments.Target, arguments.Mesh, arguments.Data, arguments.Orientation, arguments.Rotation)
			end
		end)
	end
end

return module