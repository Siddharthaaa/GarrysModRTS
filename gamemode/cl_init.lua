include( "shared.lua" )

gui.EnableScreenClicker( true ) 


hook.Add("GUIMousePressed","gui_mouse_pressed_test",function(key,vector)
			print("MAUS TEST")
			if (key == MOUSE_RIGHT)then
				--gui.EnableScreenClicker( false )
			end 
			if (key == MOUSE_LEFT) then
				local tr = util.QuickTrace( LocalPlayer():GetShootPos(), vector*10000, LocalPlayer() )
				--print( tr.HitPos )
				--print(vector)
				--print( gui.ScreenToVector( gui.MousePos() ))
				--PrintTable(tr)
				if(IsValid(tr.Entity)) then
					SelectEntity(tr.Entity)
				
				--createEntity("kaserne",tr.HitPos+Vector(0,0,5))	
				else
					setDefaultOptions()
				end
			end
		end
	)

function SelectEntity(ent)

	
	local funcs = ent:GetFunctions()
	SetOptionsOnPanel(funcs)

end

function SetOptionsOnPanel(funcs)
	local existingElements = optionsGrid:GetItems()
	PrintTable(existingElements)
	--print (#existingElements)
	for i=#existingElements,1,-1  do
		optionsGrid:RemoveItem(existingElements[i])
		--print (i)
		--print (" deleted")
	
	end
	for name, func in pairs(funcs) do
		local butt = vgui.Create("DButton")
		butt:SetSize(50,50)
		butt:SetText(name)
		butt.DoClick = func
		optionsGrid:AddItem(butt)
	end
end

function setDefaultOptions()
	SetOptionsOnPanel({["kaserne"]=function()
	local tr = LocalPlayer():GetEyeTrace()
	createEntity("kaserne",tr.HitPos + Vector(0,0,5))
	
	end})
end

panel = vgui.Create("DPanel")


panel:SetVisible(true)
panel:SetSize(600,100)
panel:SetPos(100,ScrH()-120)
panel:SetBackgroundColor(Color(120,120,120,120))
--panel:SetCols(6)

--panel:SetColor(Color(120,120,120))
--panel:MakePopup()

optionsGrid = vgui.Create("DGrid",panel)
optionsGrid:SetCols(6)
optionsGrid:SetRowHeight(50)
optionsGrid:SetColWide(50)

setDefaultOptions()


net.Receive("Clicker_off",function(len)
	gui.EnableScreenClicker( false )

end)

net.Receive("Clicker_on",function(len)
	gui.EnableScreenClicker( true )

end)

function createEntity(name,pos)
	
	net.Start("CreateEntity")
	local infos ={}
	infos.pos=pos;
	infos.name=name
	--net.WriteString(name)
	net.WriteTable(infos)
	net.SendToServer()

end

function removeEntity(ent)
	print(ent)
	net.Start("RemoveEntity")
	--net.WriteString(name)
	net.WriteEntity(ent)
	net.SendToServer()
end