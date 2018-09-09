AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "lua/cl_gui.lua" )
AddCSLuaFile( "lua/cl_communication.lua" )
AddCSLuaFile( "lua/communication.lua" )
AddCSLuaFile( "lua/player_extension.lua" )



include("lua/communication.lua")
include( "shared.lua" )
include( "lua/player_extension.lua" )



--include ("botTest.lua");


function removeEntity(ent)
	ent:Remove()

end

function GM:PlayerSpawn(ply)
	ply:SetMoveType( 	MOVETYPE_NOCLIP    )
	ply:SetNWInt("Gold",1000)
	--if (ply:GetFraction() == nil) then
		--ply:SetFraction(ents.Create("fraction"))
	--end
	
end


function createEntity(name,pos)

	local ent = ents.Create(name)
	--print(IsValid(ent))
	--PrintTable(scripted_ents.GetList())
	if(!IsValid(ent) or ent == NULL) then return end
--print("Entity created: " .. name)
--print("On Pos:" .. pos.x .. "  " .. pos.y .. "  " .. pos.z)
	
	
	ent:SetPos(pos)
	ent:Spawn()
	return ent
		
end
