

util.AddNetworkString("CreateEntity")
util.AddNetworkString("RemoveEntity")
util.AddNetworkString("Clicker_off")
util.AddNetworkString("Clicker_on")
util.AddNetworkString("ExecFunctionOnEntity")
util.AddNetworkString("ExecFunctionOnEntityTmp")
util.AddNetworkString("Clicker_on")

util.AddNetworkString("SetSynchronizedVariablesOnEntity")


net.Receive("CreateEntity",function(len, ply)

	--local entName = net.ReadString()
	local infos = net.ReadTable()
	
	local ent = createEntity(infos.name,infos.pos)
	ent:SetFraction(ply:GetFraction())

end)

net.Receive("RemoveEntity",function(len, ply)

	local ent = net.ReadEntity()
	ent:Remove()
end)

net.Receive("ExecFunctionOnEntity", function(len,ply)
	local ent = net.ReadEntity()
	
	local index = net.ReadString()
	
	local func = ent.Functions[index]
--print(CanExecEntityFunction(ply,func))
	if(CanExecEntityFunction(ply,func)) then
	
		if(ply:GetFraction():PayCosts(func.Costs)) then
			
			ent:AddTask(func.Name,func.Function,{ent},func.TimeCost,true)
			
			--ent.tmp =func["Function"]
			--ent:tmp(ent)
		end
	end
end)

--synchronized all named variables to the client
function UpDateOnClient(ent,namesTable,players)
	local table = {}
	--PrintTable(players)
	for k,v in pairs(namesTable) do
		table[v] = ent[v]
	end
	
	for k,ply in pairs(players) do
		net.Start("SetSynchronizedVariablesOnEntity", false)
		net.WriteEntity(ent)
		net.WriteTable(table)
		net.Send(ply)
	end
end

function CanExecEntityFunction(ply,func)
	if (func == nil) then return false end
	
	local frac = ply:GetFraction()
	
	
	if(frac:CanPayCosts(func.Costs)==false) then return false end
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

