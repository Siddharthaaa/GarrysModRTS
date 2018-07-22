

util.AddNetworkString("CreateEntity")
util.AddNetworkString("RemoveEntity")
util.AddNetworkString("Clicker_off")
util.AddNetworkString("Clicker_on")
util.AddNetworkString("ExecFunctionOnEntity")
util.AddNetworkString("ExecFunctionOnEntityTmp")
util.AddNetworkString("Clicker_on")


net.Receive("CreateEntity",function(len, ply)

	--local entName = net.ReadString()
	local infos = net.ReadTable()
	--local tr = ply:GetEyeTrace()
	--PrintTable (tr)
	
	--createEntity(entName,tr.HitPos + Vector(0,0,5))
	createEntity(infos.name,infos.pos)


end)

net.Receive("RemoveEntity",function(len, ply)

	local ent = net.ReadEntity()
	ent:Remove()
end)

net.Receive("ExecFunctionOnEntity", function(len,ply)
	local ent = net.ReadEntity()
	
	local index = net.ReadString()
	--local entFull = ents.GetByIndex(67)
	
	--print (ent)
	--print ("Index: " .. index .." blabl")
	--PrintTable(ent.Functions)
	local func = ent.Functions[index]
--print(CanExecEntityFunction(ply,func))
	if(CanExecEntityFunction(ply,func)) then
	
		if(ply:PayCosts(func.Costs)) then
			
			ent:AddTask(func.Name,func.Function,{ent},func.TimeCost,true)
			
			--ent.tmp =func["Function"]
			--ent:tmp(ent)
		end
	end
end)

function CanExecEntityFunction(ply,func)
	if (func == nil) then return false end
	if(ply:CanPayCosts(func.Costs)==false) then return false end
	return true
end

net.Receive("ExecFunctionOnEntityTmp", function(len,ply)
	local ent = net.ReadEntity()
	local name = net.ReadString()
	local opts = net.ReadTable()
	--local entFull = ents.GetByIndex(67)
	local func = ent[name]
	if(func != nil) then
		func(ent, unpack(opts))
	end
end)