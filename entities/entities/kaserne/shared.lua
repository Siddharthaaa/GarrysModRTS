AddCSLuaFile ("lua/selectable_interface.lua")

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName ="Kaserne"

ENT.Spawnable = true

ENT.HealthPoints = 1000
ENT.MaxHealth = 1000
ENT.Functions ={}

ENT.Model = "models/hunter/tubes/tubebend2x2x90.mdl"

ENT.Icon = "materials/portraits/kaserne.png"

ENT.Description = "Eine Kaserne, welche unermüdlich Soldaten produziert"

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

ENT.Functions["0"] = {["Name"]="Destroy",
		["Description"]="Destroy Unit",
		["ExecOn"] ="server",
		["Function"] = function(self) removeEntity(self) end,
		["TimeCost"] = 0,
		["Costs"] = {["Gold"]=0}
		
		}

		
		
ENT.Functions["1"] = {["Name"]="Soldat",
		["Description"]="Create a Unit",
		--["Function"] = ENT.CreateZombie,
		["Function"] = function(self)
			self:BuildUnit("base_kibot")
			end,
		
		["ExecOn"] ="server",
		["TimeCost"] = 3.0,
		["Costs"] = {["Gold"]=100}
		
		}


function ENT:GetFunctions()
	local allFunctions ={}
	
	for k,v in pairs(self.Functions) do
		allFunctions[v["Name"]] = k
		--PrintTable( v)
	end
	
	return allFunctions
end