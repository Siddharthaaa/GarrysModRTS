AddCSLuaFile()

local ply = FindMetaTable("Player")

ply.Fraction = nil

function ply:SetupDataTables()
	local fl=31
	local ent =31
	local str = 31
	local int =31
	local vec =31
	local bool =31
	local angl = 31
	
    self:NetworkVar("Int",int , "Gold") ;int = int -1
    self:NetworkVar("Int",int , "Wood") ;int = int -1
    self:NetworkVar("Int",int , "Iron") ;int = int -1
	self:NetworkVar("Entity",ent,"Fraction");ent = ent- 1
	
	
end

function GM:PlayerInitialSpawn( ply )
	
	--TODO Fraction choose Menu
	local fraction = ents.Create("fraction_base")
	fraction:Spawn()
	ply:SetFraction(fraction)
	--fraction:ShowInterface(ply)
	
end

function ply:Think()
	

end

 -- depricated
function ply:CanPayCosts(costs)
	for k, v in pairs(costs) do
		
		if(self:GetNWInt(k,0) < v) then
			--print("TTTTTTTTTTTTTEEEEEEEEEEEEEEESSSSSSSSSSSSTTTTTTTTTTT")
			return false
		end
	end
	
	return true
end
 
 -- depricated
function ply:PayCosts(costs)
	
	if(!self:CanPayCosts(costs)) then return false end
	
	for k, v in pairs(costs) do
		self:SetNWInt(k, self:GetNWInt(k) - v)
	end
	
	return true

end


function ply:SetFraction(frac)

	frac:RegisterPlayer(self)
	self:SetNWEntity("Fraction",frac)

end

function ply:GetFraction()
	return self:GetNWEntity("Fraction")
end
