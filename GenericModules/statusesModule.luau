local statusFolder = script.Parent.Statuses:GetChildren()
local statuses = {
	cache = {
		
	}
}

for i,v in statusFolder do
	statuses.cache[v.Name] = require(v)
end

function statuses.Add(target, status : string, params)
	--print(target.Name .. " AND " .. status)
	local statusMod = statuses.cache[status]
	print(statuses.cache)
	if statusMod and statusMod["Add"] then
		statusMod.Add(target, params)
	end
	local dur = params.dur or math.huge
		if not target:GetAttribute(status) then
		target:SetAttribute(status, dur)
		task.spawn(function()
			local lastTick = tick()
			while(target:GetAttribute(status)) do
				task.wait()
				local timeElapsed = tick() - lastTick
				target:SetAttribute(status, target:GetAttribute(status) - timeElapsed)
				--print(target:GetAttribute(status))
				lastTick = tick()
				if not target:GetAttribute(status) or target:GetAttribute(status) <= 0 then
					statuses.Remove(target, status)
					
				end
			end
		end)
	else
		target:SetAttribute(status, dur)
	end
end

function statuses.Remove(target, status)
	print("REMOVAL HAPPENING")
	print(status)
	local statusMod = statuses.cache[status]
	if statusMod and statusMod["Remove"] then
		statusMod.Remove(target)
	end
	target:SetAttribute(status, false)
end


return statuses
