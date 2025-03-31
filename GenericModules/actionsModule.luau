local actionchecker = {
	blacklists = {
		attack = {'Stun', 'Attacking', 'Blocking'},
		block = {'Stun', 'Attacking',},
		launchAttack = {'Stun', 'Blocking'},
		run = {'Stun', 'Blocking', "Attacking"},
		dash = {'Stun', 'Attacking'},
		doubleJump = {'Stun', "Attacking"},
		takeDamage = {}
	},
	whitelists = {
		launchAttack = {"Attacking"},
	}
}

--function actionchecker.init(files)
	--actionchecker.plr = files.Player
--end

function actionchecker.check(action, target)
	if not target then
		target = game:GetService("Players").LocalPlayer.Character
	end

	local valid = true

	-- blacklist check
		if actionchecker.blacklists[action] then
			for _, blacklist in actionchecker.blacklists[action] do
				if target:GetAttribute(blacklist) then
					if action == "launchattack" then
						warn("invalid due to "..blacklist.." blacklist violation")
					end
					valid = false
				end
			end

		-- whitelist check
		if actionchecker.whitelists[action] then
			for _, whitelist in actionchecker.whitelists[action] do
				if not target.statuses[whitelist] then
					if action == "launchattack" then
						warn("invalid due to "..whitelist.." whitelist violation")
					end
					valid = false
				end
			end
		end
	end

	return valid
end

return actionchecker