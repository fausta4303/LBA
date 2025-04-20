local module = {}
local ss = game:GetService("ServerStorage")
local rs = game:GetService("ReplicatedStorage")
local emitParticlesEvent = rs.RemoteEvents.emitParticlesEvent
local deleteParticlesEvent = rs.RemoteEvents.deleteParticlesEvent


--char: the player's character whomst the particles need to emit from
--givenParticlePath: A table of strings, with each string being a part of 
				   --the filepath to the desired particle (do not include rs.Assets).
				   --Example: If you want Particles.Charge.ChargeTier1, you would pass:
				   --{"Particles","Charge","ChargeTier1"}
--bodyPart: String name of the body part you want the particle to be on

module.emitParticles = function(char, givenParticlePath, bodyPart)
	--the last element of givenParticlePath should be the name of the particle(s) we want
	local particleName = givenParticlePath[#givenParticlePath]
	local bodyPart = char:FindFirstChild(bodyPart) --sets bodyPart to the ACTUAL part rather than the string
	
	--concat the table into string form with .'s. This is stored as an attribute which will
	--be used to track VFX that need to be generated when a player joins the game mid-way]]
	local pathString = table.concat(givenParticlePath,".")
	char:SetAttribute(particleName, pathString .. "." .. bodyPart.Name)
	
	--Send the table representing the file path and the body part to all clients
	emitParticlesEvent:FireAllClients(givenParticlePath, bodyPart) 
end


--char: the player's character whomst the particles need to be removed from

--givenParticleString: a string representative of the filepath to the particle.
					--Has the body part the existing particle is attached to as the last word
					--Example: "Particles.Charge.ChargeTier1.Right Arm"

module.deleteParticles = function(char, givenParticleString)
	--Turn filepath into table, splitting into data by .'s.
	local pathTable = string.split(givenParticleString,".")
	
	--bodyPart is the last index, retrieve the name of the part and then find it
	local bodyPart = pathTable[#pathTable]
	bodyPart = char:FindFirstChild(bodyPart)
	
	--name of the particle is at last index minus 1. After getting the particle's name, delete the
	--attribute that contained givenParticleString
	local particleName = pathTable[#pathTable-1]
	char:SetAttribute(particleName,nil)
	
	--Send the particle name and body part to all clients for deletion
	deleteParticlesEvent:FireAllClients(particleName, bodyPart)
end

return module
