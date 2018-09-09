include ("shared.lua")
include("lua/cl_communication.lua")
include ("lua/selectable_interface.lua")

function ENT:Draw()

	
	self:DrawModel()
	--self:DrawEntityOutline(1)
	if (self.IsSelected) then
		self:DrawHealthBar(1000,75)
	end
	
end

--internal function



