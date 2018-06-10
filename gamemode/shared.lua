GM.Name = "ShitSmocker"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"


DeriveGamemode("sandbox");


function GM:KeyRelease( player, key )
	if ( key == IN_USE ) then
		print( "hi" )
		print (player)
		print ("hi2")
	end
end

--wird überschrieben??


function GM:Initialize()
	-- Do stuff
	--gui.EnableScreenClicker( true ) 
	
	self.BaseClass.Initialize(self)
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
	hook.Add("GUIMousePressed","gui_mouse_pressed_test",function(key,vector)
			print("MAUS TEST")
			if (key == MOUSE_RIGHT)then
				--gui.EnableScreenClicker( false )
			end 
		end
	)
	
	hook.Add("GUIMouseReleased","gui_mouse_released_test",function(key,vector)
			if (key == MOUSE_RIGHT)then
				--gui.EnableScreenClicker( true )
			end
		end
	)
	
	hook.Add("PlayerButtonDown","KeyListener",function(ply,key)
			print("BUTTON" .. key .." pressed")
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