ENT.IsSelected = false
ENT.IsSelectable = true
function ENT:Select()
	self.IsSelected = true
	self:OnSelect()
	
	local frac = self:GetFraction()
	if(IsValid(frac) ) then
		print(frac)
		frac:SelectUnit(self)
	end
	
	--self:EmitSound("BereitZuDienen.wav")
end
function ENT:OnSelect()
	
end

function ENT:UnSelect()
	self.IsSelected = false
	
end

function ENT.IsSelectable()
	return IsSelectable
end 

function ENT:DrawHealthBar(length, height)
	
	length = length or 500
	height = height or 50

	local angTmp = (self:EyePos() - LocalPlayer():EyePos()):Angle()
	angTmp:RotateAroundAxis(angTmp:Forward(),90)
	angTmp:RotateAroundAxis(angTmp:Right(),90)
	--cam.Start3D2D(self:GetPos()+self:OBBMaxs(), ang, 1)
	cam.Start3D2D(self:GetPos()+self:OBBMaxs(), angTmp, 0.1)
		local l = length
		local w = height
		local x1 = l*self:GetHealthPoints()/self:GetMaxHealth()
		draw.RoundedBox(w/2,0,0,x1,w,Color(10,200,20))
		draw.RoundedBox(w/2,x1,0,l-x1,w,Color(220,30,40))
		
		
	
	cam.End3D2D()
end