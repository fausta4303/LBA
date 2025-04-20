local module = {}

module.AddCharge = function(char, amount)
	local charge = char:GetAttribute("Charge")
	if charge == 10 or (charge + amount) >= 10 then
		char:SetAttribute("Charge", 10)
	else
		char:SetAttribute("Charge", charge + amount)
	end
end

module.RemoveCharge = function(char, amount)
	local charge = char:GetAttribute("Charge")
	if charge == 0 or (charge - amount) <= 10 then
		char:SetAttribute("Charge", 0)
	else
		char:SetAttribute("Charge", charge - amount)
	end
end

module.GetCharge = function (char)
	return char:GetAttribute("Charge")
end

return module
