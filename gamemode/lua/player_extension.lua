AddCSLuaFile()

local ply = FindMetaTable("Player")

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
	
	
end
 
 function ply:CanPayCosts(costs)
	for k, v in pairs(costs) do
		
		if(self:GetNWInt(k,0) < v) then
			--print("TTTTTTTTTTTTTEEEEEEEEEEEEEEESSSSSSSSSSSSTTTTTTTTTTT")
			return false
		end
	end
	
	return true
 end
 
 
 function ply:PayCosts(costs)
	
	if(!self:CanPayCosts(costs)) then return false end
	
	for k, v in pairs(costs) do
		self:SetNWInt(k, self:GetNWInt(k) - v)
	end
	
	return true

end
 
