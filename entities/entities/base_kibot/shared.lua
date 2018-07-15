AddCSLuaFile()

ENT.Type			= "ai"
ENT.Base 			= "base_entity"

ENT.Type			= "nextbot"
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

ENT.Selectable	= true
ENT.Model="models/humans/group01/female_01.mdl" 
ENT.Model="models/alyx.mdl" 
ENT.Spawnable = true

ENT.Weapon = nil

ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	local fl=0
	local ent =0
	local str = 0
	local int =0
	local vec =0
	local bool =0
	local angl = 0
	
    self:NetworkVar("Float",fl , "HealthPoints") ;fl=fl+1-- 
	self:NetworkVar("Entity",ent,"Weapon"); ent=ent+1
	
	

end

function ENT:HasWeapon()
	--print("HAAAAAAAAAAAAAAAAAAAAAHAHAHAHHA")
	return IsValid(self:GetWeapon())
end

function ENT:GetActiveWeapon()
	return self.Weapon
end

function ENT:CapabilitiesGet() 
	return bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_USE_WEAPONS , CAP_WEAPON_RANGE_ATTACK1 ,CAP_WEAPON_RANGE_ATTACK2, CAP_SQUAD ,CAP_TURN_HEAD ,CAP_MOVE_SHOOT,
		CAP_USE )

end
function ENT:GetAimVector()
	if(IsValid(self:GetWeapon() )) then
		local enm =  self:GetEnemy()
		if(!IsValid(enm)) then return nil end
		local vec = enm:OBBCenter()+enm:GetPos()
		 vec:Sub(self:GetShootPos())
		 
		 vec:Normalize()
		 return vec
		--return Vector(1000,1000,-1000)
		
	end
	
end	
function ENT:GetShootPos()
	if(IsValid(self:GetWeapon() )) then
		local muzzle = self:GetWeapon():LookupAttachment("muzzle")
		local obj = self:GetWeapon():GetAttachment(muzzle)
		--print(obj.Pos)
		scr= obj.Pos
		--print(self.CapabilitiesGet)
		--return Entity(1):EyePos()
		
		return scr
		
		
		--print ("BBBBBBBBBBBBBBBBBB" )
		--print(self.GetWeapon():GetPos())
		--return self:GetPos()+ Vector(100,100,0)
		--return self:GetWeapon():GetPos()
		
	end
	return self:EyePos()

end


