AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("ShowInterfaceOnClient")


ENT.Players = {}

function ENT:Initialize()
	
end

function ENT:CanPayCosts(costs)
	for k, v in pairs(costs) do
		
		if(self.resources[k] < v) then
			
			return false
		end
	end
	
	return true
 end
 
 
 function ENT:PayCosts(costs)
	
	if(!self:CanPayCosts(costs)) then return false end
	
	for k, v in pairs(costs) do
		self.resources[k]=self.resources[k]-v
	end
	
	UpDateOnClient(self,{"resources"},self.Players)
	return true

end

function ENT:RegisterPlayer(ply)
	table.insert(self.Players, ply)
	
end

function ENT:ShowInterface(ply)
	net.Start("ShowInterfaceOnClient")
	
	net.WriteEntity(self)
	net.Send(ply)
end

