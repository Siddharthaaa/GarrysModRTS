include ("shared.lua")


function ENT:Draw()
	self:DrawModel()
	
end

function ENT:GetFunctions()
	local allFunctions ={}
	
	allFunctions["Remove"] = function()
		removeEntity(self)
	
	end
	
	allFunctions["testent"] = function()
		createEntity("npc_zombie",self:GetPos()+Vector(0,70,0))
	end
	
	return allFunctions
end