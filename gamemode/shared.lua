GM.Name = "ShitSmocker"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"


DeriveGamemode("sandbox");



local file = file

function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
	local list = file.Find("*","../"..dir.."")
	for _, fdir in pairs(list) do
		if fdir != ".svn" then -- don't spam people with useless .svn folders
			AddDir(dir.."/"..fdir)
		end
	end
 
	for k,v in pairs(file.Find("*","../"..dir.."/*")) do
		resource.AddFile(dir.."/"..v)
	end
end
 
--AddDir("models/yourmodels")

-- TODO
AddDir("lua")


function GM:KeyRelease( player, key )
	if ( key == IN_USE ) then
	--print( "hi" )
	--print (player)
	--print ("hi2")
	end
end

--wird überschrieben??


function GM:Initialize()
	-- Do stuff
	--gui.EnableScreenClicker( true ) 
	
	--ply = LocalPlayer()
	--ply:SetMoveType(MOVETYPE_FLY)
	--ply.Entities = {}

	
	self.BaseClass.Initialize(self)
	
	
	for k,v in pairs( weapons.GetList() ) do 
	--print( v.PrintName )
	end 
	--PrintTable( hook.GetTable() )
	
	hook.Add("KeyPress","keypress_test",function(ply, key)
			if CLIENT then 
			if (key == IN_ATTACK) then
				
			end end
		end
	)
	
	hook.Add("KeyRelease","keyrelease_test",function(ply, key)
	
			if CLIENT then 
			if (key == IN_ATTACK) then
			
			end end
		end
	)
	
	-- nur mit ScreenClicker möglich
	
	
	hook.Add("GUIMouseReleased","gui_mouse_released_test",function(key,vector)
			if (key == MOUSE_RIGHT)then
				--gui.EnableScreenClicker( true )
			end
		end
	)
	
	hook.Add("PlayerButtonDown","KeyListener",function(ply,key)
			--print("BUTTON" .. key .." pressed")
			if (key == MOUSE_MIDDLE)then
				--gui.EnableScreenClicker( false )
				net.Start("Clicker_off")
				net.Send(ply)	
			end
		end
	)
	
	hook.Add("PlayerButtonUp","KeyListener",function(ply,key)
			if (key == MOUSE_MIDDLE)then
				--gui.EnableScreenClicker( true )
				net.Start("Clicker_on")
				net.Send(ply)
			end
		end
	)
	
end

-- shared
