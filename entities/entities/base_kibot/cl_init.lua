include ("shared.lua")


function ENT:Draw()
	self:DrawModel()
	
	
	local ang = self:GetAngles()
	
	
	local angTmp = (self:EyePos() - LocalPlayer():EyePos()):Angle()
	angTmp:RotateAroundAxis(angTmp:Forward(),90)
	angTmp:RotateAroundAxis(angTmp:Right(),90)
	
	--cam.Start3D2D(self:GetPos()+self:OBBMaxs(), ang, 1)
	cam.Start3D2D(self:GetPos()+self:OBBMaxs(), angTmp, 0.1)
		local l = 1000
		local x1 = l*self:GetHealthPoints()/self:GetMaxHealth()
		draw.RoundedBox(50,0,0,x1,100,Color(10,200,20))
		draw.RoundedBox(50,x1,0,l-x1,100,Color(220,30,40))
		
		
	
	cam.End3D2D()
	
end

function ENT:Think()
	self.Weapon = self:GetWeapon()
	--print(self)
	--print("thinks.....")
end