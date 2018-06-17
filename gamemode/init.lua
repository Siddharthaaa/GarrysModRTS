AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

--include ("botTest.lua");

util.AddNetworkString("CreateEntity")
util.AddNetworkString("RemoveEntity")
util.AddNetworkString("Clicker_off")
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

function createEntity(name,pos)

	local ent = ents.Create(name)
	--print(IsValid(ent))
	--PrintTable(scripted_ents.GetList())
	if(!IsValid(ent) or ent == NULL) then return end
	print("Entity created: " .. name)
	print("On Pos:" .. pos.x .. "  " .. pos.y .. "  " .. pos.z)
	
	
	ent:SetPos(pos)
	ent:Spawn()
		
end
