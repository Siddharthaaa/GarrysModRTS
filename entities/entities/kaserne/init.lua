AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/tubes/tubebend2x2x90.mdl")
	--models/props_junk/cardboard_box002a_gib01.mdl
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys=self:GetPhysicsObject()
	
	if phys:IsValid() then
		--phys:Wake()
	end
	
	

end

function ENT:GetFunctions()
	
end
