AddCSLuaFile()
AddCSLuaFile ("lua/selectable_interface.lua")
--AddCSLuaFile("lua/ent_ext/schedule.lua")

--ENT.Type			= "ai"
--ENT.Base 			= "base_entity"

ENT.Type			= "nextbot"
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

ENT.PrintName = "Prototyp-Bot"

ENT.Model="models/humans/group01/female_01.mdl" 
ENT.Model="models/alyx.mdl" 
ENT.Spawnable = true

ENT.Functions ={}

ENT.Icon = "materials/portraits/soldier_1.png"

ENT.Weapon = nil

ENT.AutomaticFrameAdvance = true

ENT.Description = "Der Erste Bot \nLäuft komisch und schießt aus den Augen"

function ENT:GetName()
	return self.PrintName or "NoName"
end

function ENT:GetDescription()
	return self.Description or "NoDescription"
end

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
	self:NetworkVar("Entity",ent,"Fraction"); ent=ent+1
	

end


ENT.Functions["0"] = {["Name"]="Verrat",
		["Description"]="Make a unit hostile",
		["ExecOn"] ="server",
		["Function"] = function(self) local fraction = ents.Create("fraction_base")
			fraction:Spawn()
			self:SetFraction(fraction) end,
		["TimeCost"] = 0,
		["Costs"] = {["Gold"]=0}
		
		}

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
		
		
	end
	return self:EyePos()

end


