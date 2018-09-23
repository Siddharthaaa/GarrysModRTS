include ("shared.lua")
include ("lua/selectable_interface.lua")

function ENT:Draw()
	self:DrawModel()
	
	self.ScreenPos = self:GetPos():ToScreen()
	
	if (self.IsSelected) then
		self:DrawHealthBar()
	end
	
end


function ENT:Think()
	self.Weapon = self:GetWeapon()
	--print(self)
	--print("thinks.....")
end

function ENT:GetPortrait()
	return self.Icon
end