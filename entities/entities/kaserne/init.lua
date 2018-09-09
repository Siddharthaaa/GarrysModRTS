AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("lua/schedule.lua")

include("shared.lua")

include("../../lua/schedule.lua")


function ENT:Initialize()

	self:SetModel(self.Model)
	--models/props_junk/cardboard_box002a_gib01.mdl
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys=self:GetPhysicsObject()
	
	if phys:IsValid() then
		--phys:Wake()
	self:SetHealth(self.HealthPoints)
	self:SetHealthPoints(self.HealthPoints)
	
	self:SetMaxHealth(self.MaxHealth)
	
	end
	
	--print("TTTTTTTTEEEEEEEEEEEESSSSSSSSTTTTTT \n " .. self.Functions["1"]["TimeCost"])
	--PrintTable( self.Functions["1"])

end 

function ENT:OnTakeDamage( damage ) 
	
	local dmg = damage:GetDamage()
	
	self:SetHealth(self:Health()-dmg*10)
	
	
	if(self:Health() <=0) then
		self:OnDestroy()
	end
	self:SetHealthPoints(self:Health())
	--self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	--PrintTable(self:GetSequenceList())

end

function ENT:OnDestroy(damage)
	local body = ents.Create( "prop_physics" )
	body:SetPos( self:GetPos() )
	body:SetModel( self:GetModel() )
	body:Spawn()

	self:Remove()

	timer.Simple( 100, function()

		body:Remove()

	end )
	--self:BecomeRagdoll( dmginfo )

end