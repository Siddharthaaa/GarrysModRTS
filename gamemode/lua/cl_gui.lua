AddCSLuaFile()

selectedEntities = nil

posFirstClick = {0,0}
posSecClick = {0,0}

appendedModel=nil

appendedFunc=nil

hook.Add("HUDPaint","PaintSelectionBox", function()
		if(input.IsMouseDown(MOUSE_LEFT) and posFirstClick != nil) then
			
			--print(posFirstClick)
			
		
			x1,y1,x2,y2 = GetSelectBoxCoordinates()
			
			
			surface.SetDrawColor(7, 188, 97)
			surface.DrawOutlinedRect(x1,y1,x2-x1,y2-y1)
			surface.DrawOutlinedRect(x1+1,y1+1,x2-x1-2,y2-y1-2)
			
		end
		
		if(selectedEntities) then
		for k,v in pairs(selectedEntities) do
			local vec = v:GetPos()
			local pos = vec:ToScreen()
			
			local w = 100;
			local h = 20
			
			local x1
			x1 = w* (v:Health() / v:GetMaxHealth())
			
			print(v:Health())
			surface.SetDrawColor(10,222,30)
			surface.DrawRect(pos.x,pos.y,x1,h)
			surface.SetDrawColor(200,2,30)
			surface.DrawRect(pos.x +x1,pos.y,w-x1,h)
			
			
		end
		end

	end
)

function GetSelectBoxCoordinates()

			local x1 = posFirstClick[1]
			local y1 = posFirstClick[2]
			local x2 = gui.MouseX()
			local y2 = gui.MouseY()
			
			if(x1>x2) then
				x1,x2 = x2,x1
			end
			if(y1>y2) then
				y1,y2 = y2,y1
			end
			
			return x1,y1,x2,y2
end

hook.Add( "PreRender", "appendedEnt", function()
	if(appendedModel != nil) then
		local tr = util.QuickTrace( LocalPlayer():GetShootPos(), gui.ScreenToVector( gui.MousePos() )*10000, LocalPlayer() )
		--print( tr.HitPos )
		appendedModel:SetPos(tr.HitPos)
	end
end)


hook.Add("GUIMousePressed","gui_mouse_pressed_select_ent",function(key,vector)
			--print("MAUS TEST")
			if (key == MOUSE_RIGHT)then
				if(selectedEntities != nil) then
					local ent = GetEntityOnMouse()
					
					if(ent) then
						for k,v in pairs (selectedEntities) do
							--print(v)
							
							ExecEntityFunctionTmp(v,"SetEnemy",{ent})
						end
					
					else 
					
						for k,v in pairs (selectedEntities) do
								--print(v)
								local tr = util.QuickTrace( LocalPlayer():GetShootPos(), vector*10000, LocalPlayer() )
								ExecEntityFunctionTmp(v,"SetTargetPos",{tr.HitPos})
						end
					end
						
				end
			end 
			if (key == MOUSE_LEFT) then
				
				posFirstClick = {gui.MousePos()}
				print("AAAAAAAAAAAAAA")
				SelectEntity(GetEntityOnMouse())
				--createEntity("kaserne",tr.HitPos+Vector(0,0,5))	
			else
				setDefaultOptions()
			end
			
		end
	)
	
function GetEntityOnMouse()
	local tr = util.QuickTrace( LocalPlayer():GetShootPos(), gui.ScreenToVector( gui.MousePos() )*1000000, LocalPlayer() )
			--PrintTable(tr)
	if(IsValid(tr.Entity)) then
		print(tr.Entity)
		return tr.Entity
	end
	
	return nil
					

end

hook.Add("GUIMousePressed","mousePressedAppendedEnt",function(key,vector)
	if (key == MOUSE_RIGHT)then
				removeEntOnMouse()
	end 
	if (key == MOUSE_LEFT) then
		if(appendedFunc != nil) then
			appendedFunc()
			--removeEntOnMouse()
		end
	end
end)
	
hook.Add("GUIMouseReleased","gui_mouse_release_select_ent",function(key,vector)
		if (key == MOUSE_LEFT) then
				--posFirstClick = nil
				posSecClick = {gui.MousePos()}
				
				
				x1,y1,x2,y2 = GetSelectBoxCoordinates()
				if(x2-x1 < 10 or y2-y1 <10) then return end
				
				selectedEntities ={}
				
				for k,v in pairs(ents.GetAll()) do 
				
					if(v.Selectable) then
						
						point= v:GetPos():ToScreen()
						 
						x= point.x
						y=point.y
						--print(x,y)
						--print(v)
						if(x>x1 and x<x2 and y>y1 and y<x2) then
							SelectEntity(v,true)
						end
					end
					
				end
		end
	end
)

function SelectEntity(ent, add)
	
	if(!IsValid(ent)) then return false end
	if(add) then
		selectedEntities[#selectedEntities+1] = ent
	else
		selectedEntities= {ent}
	end
	local funcs = {}
	local entFunctions = ent.Functions or {}
	
	for k, v in pairs(entFunctions) do
		if(v["ExecOn"] == "server") then
			funcs[v["Name"]] = function()
				--print(v["Name"] .. k .. "   AAAAA")
				ExecEntityFunction(ent,k)
			end
		
		else
			funcs[v["Name"]] = funcs[v["Function"]]
		end
		
	end
	
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
		--local tr = LocalPlayer():GetEyeTrace()
		
		local func = function ()
		local tr = util.QuickTrace( LocalPlayer():GetShootPos(), gui.ScreenToVector( gui.MousePos() )*10000, LocalPlayer() )
		createEntity("kaserne",tr.HitPos + Vector(0,0,5)) end
		
		appendEntOnMouse("kaserne", func)
		
	end})
end

function appendEntOnMouse(entName, func)
	local tmpEnt = scripted_ents.Get( entName )
	--PrintTable(tmpEnt)
		
	appendedModel = ClientsideModel( tmpEnt.Model,RENDERGROUP_OPAQUE  )
	appendedModel:SetColor(40,40,200)
	appendedModel:SetKeyValue( "rendermode", RENDERMODE_TRANSTEXTURE )
	appendedModel:SetKeyValue( "renderamt", "100" )
	
	appendedFunc = func
end

function removeEntOnMouse()
	if(appendedModel != nil) then
		appendedModel:Remove()
		appendedFunc = nil
		appendedModel=nil
	end 
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