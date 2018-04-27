GM.Name = "ShitSmocker"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:KeyRelease( player, key )
	if ( key == IN_USE ) then
		print( "hi" )
	end
end

function GM:KeyRelease( player, key )
	if ( key == IN_USE ) then
		print( "gi" )
	end
end

function GM:Initialize()
	-- Do stuff
	gui.EnableScreenClicker( true ) 
	
	--print( hook.GetTable() )
	
	hook.Add("KeyPress","keypress_test",function(ply, key)
	
			if (key == IN_USE) then
			gui.EnableScreenClicker( false )
			local pl = LocalPlayer()
	 print("davor")
	print(pl)
	print ("danach")
			end
		end
	)
	
	hook.Add("KeyRelease","keyrelease_test",function(ply, key)
	
			if (key == IN_USE) then
			gui.EnableScreenClicker( true )
			end
		end
	)
	
end