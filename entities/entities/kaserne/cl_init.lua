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


local matOutlineWhite 	= Material( "white_outline" )
local ScaleNormal		= 0
local ScaleOutline1		= 1
local ScaleOutline2		= 1.1
local matOutlineBlack 	= Material( "black_outline" )

function ENT:DrawEntityOutline( size )
	
	size = size or 1.0
	render.SuppressEngineLighting( true )
	render.SetAmbientLight( 1, 1, 1 )
	render.SetColorModulation( 1, 1, 1 )
	
		// First Outline	
		self:SetModelScale( ScaleOutline2 * size )
		render.MaterialOverride( matOutlineBlack )
		self:DrawModel()
		
		
		// Second Outline
		self:SetModelScale( ScaleOutline1 * size )
		render.MaterialOverride( matOutlineWhite )
		self:DrawModel()
		
		// Revert everything back to how it should be
		render.MaterialOverride( nil )
		self:SetModelScale( ScaleNormal, 0 )
		
	render.SuppressEngineLighting( false )
	
	local col = self:GetColor()
	render.SetColorModulation( col.r/255, col.g/255, col.b/255 )

end


function ENT:OnSelect()
	print("ONSELCT")
	--self:GetFraction():SelectUnit(self)
end

function ENT:GetPortrait()
	return "materials/portraits/kaserne.png"
end
