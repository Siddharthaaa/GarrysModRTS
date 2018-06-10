AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

--include ("botTest.lua");

util.AddNetworkString("CreateEntity")
util.AddNetworkString("Clicker_off")
util.AddNetworkString("Clicker_on")


net.Receive("CreateEntity",function(len, ply)

	local entName = net.ReadString()
	local ent = ents.Create(entName)
	local ent = ents.Create(entName)
	
	print(IsValid(ent))
	--PrintTable(scripted_ents.GetList())
	if(!IsValid(ent) or ent == NULL) then return end
	print("Entity created!!!!!!" .. entName)
	local tr = ply:GetEyeTrace()
	--PrintTable (tr)
	ent:SetPos(Vector(255,255,-12282))
	ent:SetPos(tr.HitPos + Vector(0,0,5))
	ent:Spawn()


end)
