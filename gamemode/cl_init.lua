include( "shared.lua" )

include("lua/cl_gui.lua")
include("lua/cl_communication.lua")

gui.EnableScreenClicker( true ) 




local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
	
	-- Don't return anything here, it may break other addons that rely on this hook.
end )