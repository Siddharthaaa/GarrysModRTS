include ("shared.lua")

function ENT:Draw()
	
end

function ENT:Initialize()
	
	self.HasInterface = false
	self.InterfaceElements ={}
	--print("BBBBBBBBBBBBBBBBBBBBBBBBB")
	self:ShowInterface(LocalPlayer())
end

function ENT:Think()
	--print(LocalPlayer():GetPos())
end

function ENT:CreateInterface(ply)
	
	if(self.HasInterface == false) then
		self:CreateBuildingPanel(false)
		self:CreateMapPanel(false)
		self:GreateSelectedUnitsPanel(false)
		self.HasInterface = true
	end
end

function ENT:CreateBuildingPanel(show)
	local frame = vgui.Create( "DPanel" )
	frame:SetPos(10,ScrH()-310)
	frame:SetSize( 300, 300 )
	

	testCategory = vgui.Create("DCollapsibleCategory",frame)
	testCategory:SetLabel("Gebäude")
	testCategory:SetExpanded(0)
	testCategory:SetPos(10,10)
	testCategory:SetSize(200,20)
	local DermaList = vgui.Create( "DPanelList", testCategory )	// Make a list of items to add to our category ( collection of controls )
	DermaList:SetSpacing( 5 )							 // Set the spacing between items
	DermaList:EnableHorizontal( false )					// Only vertical items
	DermaList:EnableVerticalScrollbar( true )			 // Enable the scrollbar if ( the contents are too wide
	testCategory:SetContents( DermaList )					// Add DPanelList to our Collapsible Category


	local buildings = {"kaserne", "kaserne2","base_kibot"}

	for k,v in pairs(buildings) do
		local CatContent = vgui.Create("DModelPanel")
		CatContent:SetSize( 100, 100 )
		
		local tmpEnt = scripted_ents.Get( v )
		CatContent:SetModel( tmpEnt.Model )
		DermaList:AddItem( CatContent)
		CatContent.OnMousePressed = function(keyCode )
			--print("AAAAAAAAAAAAAA:")
			
			local func = function ()
			local tr = util.QuickTrace( LocalPlayer():GetShootPos(), gui.ScreenToVector( gui.MousePos() )*10000, LocalPlayer() )
			createEntity(v,tr.HitPos + Vector(0,0,5)) 
			end
			
			appendEntOnMouse(v, func) 
			--function icon:LayoutEntity( Entity ) return end -- disables default rotation
			--function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
		
		end
	
	end
	frame:SetVisible(show)
	self.InterfaceElements.Building = frame
	return frame
end

function ENT:CreateMapPanel(show)
	local h, w = 200,200

	local name = "Map"
	if(self.InterfaceElements[name] != nil ) then return end
	
	local panel = vgui.Create("DPanel")
	panel:SetSize(h,w)
	
	local posx, posy
	posx=(ScrW()-w)/2 
	posy = ScrH()-h
	
	panel:SetPos(posx,posy)
	
	
	local panelMap = vgui.Create("DPanel",panel)
	panelMap:Dock(FILL)
	function panelMap:Paint(w, h)
		
		local x, y = self:LocalToScreen(0,0)
			
			local pos = LocalPlayer():GetPos()
			pos:Add(Vector(0,0,300))
			origin = Vector(-40,200,-10700)
			
			render.RenderView( {
			aspectratio = 1,
			origin = origin,
			angles = Angle( 90, 0, 0 ),
			x = x, y = y,
			w = w, h = h
		} )
	
	end
	panel:SetVisible(show)
	self.InterfaceElements[name]= panel
	return panel
end

function ENT:GreateSelectedUnitsPanel(show)

	local w,h = 300, 200
	local name = "UnitsPanel"
	if(self.InterfaceElements[name] != nil ) then return end

	local panel = vgui.Create("DPanel")
	panel:SetSize(w,h)
	panel:SetPos(ScrW()/2+200,ScrH()-h)
	
	self.InterfaceElements[name]= panel
	panel:SetVisible(show)
	panel:SetBackgroundColor(Color(0,0,0,220))
	
	function panel:SetFunctionsButtons()
		local funcs = {}
		local entFunctions = ent.Functions or {}
		
		for k, v in pairs(entFunctions) do
			
			if(v["ExecOn"] == "server") then
				funcs[v["Name"] ] = function()
					
					ExecEntityFunction(ent,k) 
				end
			
			else
				funcs[v["Name"] ] = funcs[v["Function"] ]
			end 
			
		end
		
		local existingElements = optionsGrid:GetItems()
	--PrintTable(existingElements)
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
	
	return panel 

end

function ENT:ShowInterface(ply)
	if(self.HasInterface == false)then
		self:CreateInterface(ply)
	end

	self:SetGuiVisible(true)
end

function ENT:SetGuiVisible(show)
	print("AAAAAAAAAAAAAAAAAA")
	for k,v in pairs(self.InterfaceElements) do
		print(k .. ": ")
		print(v)
		v:SetVisible(show)
	end

end

function ENT:SelectUnit(ent)
	
	self:FillUnitPanel(ent)
	
end

function ENT:FillUnitPanel(ent)

	local unitPanel = self.InterfaceElements["UnitsPanel"]
	
	unitPanel:Clear()
	
	local name = vgui.Create("DLabel",unitPanel)
	name:SetText(ent.PrintName)
	name:SetPos(10,5)
	
	local icon = vgui.Create("DImage",unitPanel)
	icon:SetImage(ent:GetPortrait())
	icon:SetSize(60,60)
	icon:SetPos(10,30)
	
	local HPBar = vgui.Create("DProgress",unitPanel)	
	HPBar:SetPos( 70, 30 )
	HPBar:SetSize( 200, 20 )
	HPBar:SetFraction(ent:GetHealthPoints()/ent:GetMaxHealth())
	
	local description = vgui.Create("DLabel",unitPanel)
	description:SetPos(70,40)
	description:SetSize(200,60)
	description:SetMultiline(true)
	description:SetText(ent.Description)
	
	--unitPanel:SetBackgroundColor(Color(0,0,0,200))
	
	--unitPanel:Clear()
end


net.Receive("ShowInterfaceOnClient", function (len)
	local fraction = net.ReadEntity()
	--print(fraction)
	fraction:ShowInterface()
end)


