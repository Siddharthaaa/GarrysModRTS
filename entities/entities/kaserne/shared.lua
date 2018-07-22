ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName ="Kaserne"

ENT.Spawnable = true


ENT.Functions ={}

ENT.Model = "models/hunter/tubes/tubebend2x2x90.mdl"

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
	end

self.Functions["0"] = {["Name"]="Destroy",
		["Description"]="Destroy Unit",
		["ExecOn"] ="server",
		["Function"] = function(self) removeEntity(self) end,
		["TimeCost"] = 0,
		["Costs"] = {["Gold"]=0}
		
		}

		
		
self.Functions["1"] = {["Name"]="Soldat",
		["Description"]="Create a Unit",
		--["Function"] = ENT.CreateZombie,
		["Function"] = function(self)
						local ent = createEntity("base_kibot",self:GetPos()+Vector(0,70,0)) 
							ent:SetTargetPos(self:GetPos() + self:GetAngles():Right()*-200 + Vector(math.random(-100,100),math.random(-100,100),0))
						end,
		
		["ExecOn"] ="server",
		["TimeCost"] = 5.0,
		["Costs"] = {["Gold"]=100}
		
		}
	
	--print("TTTTTTTTEEEEEEEEEEEESSSSSSSSTTTTTT \n " .. self.Functions["1"]["TimeCost"])
	PrintTable( self.Functions["1"])

end 


function ENT:GetFunctions()
	local allFunctions ={}
	
	for k,v in pairs(self.Functions) do
		allFunctions[v["Name"]] = k
		PrintTable( v)
	end
	
	return allFunctions
end