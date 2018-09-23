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
		self.InterfaceElements.Building=self:CreateBuildingPanel(false)
		self.InterfaceElements.Map = self:CreateMapPanel(false)
		self.InterfaceElements.UnitsPanel = self:CreateSelectedUnitsPanel(false)
		self.InterfaceElements.InfoBox = self:CreateInfoBox(false)
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
	
	return panel
end

function ENT:CreateSelectedUnitsPanel(show)

	local w,h = 300, 200

	local panel = vgui.Create("DPanel")
	panel:SetSize(w,h)
	panel:SetPos(ScrW()/2+200,ScrH()-h)
	panel:DockPadding(5,5,5,5)
	panel:DockMargin(5,5,5,5)

	local FunktionsPanel = vgui.Create( "DIconLayout", panel )
	FunktionsPanel:Dock( FILL )
	FunktionsPanel:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
	FunktionsPanel:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5
	
	panel.FunktionsPanel= FunktionsPanel
	
	local PortraitHullPanel = vgui.Create("DPanel", panel)
	local PortraitBox = vgui.Create("DImage", PortraitHullPanel)
	PortraitHullPanel:Dock(LEFT)
	PortraitHullPanel:SizeToContents()
	PortraitBox:SetSize(70,70)
	panel.PortraitBox = PortraitBox
	panel.PortraitHullPanel = PortraitHullPanel

	local InfoBox = vgui.Create("DListLayout",panel)
	InfoBox:Dock(TOP)
	InfoBox:DockMargin(5,5,5,5)
	panel.InfoBox = InfoBox

	local NameLabel = vgui.Create("DLabel", InfoBox)
	InfoBox.NameLabel = NameLabel

	local HPBar = vgui.Create("DProgress", InfoBox )
	InfoBox.HPBar = HPBar


	local DescriptionLabel = vgui.Create("DLabel", InfoBox)
	DescriptionLabel:SetWrap(true)
	InfoBox.DescriptionLabel = DescriptionLabel
	
	panel:SetVisible(show)
	panel:SetBackgroundColor(Color(0,0,0,220))
	
	function panel:SetFunctionsButtons(ent)
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
		
		self.FunktionsPanel:Clear()
		for name, func in pairs(funcs) do
			local butt = vgui.Create("DButton")
			butt:SetSize(50,50)
			butt:SetText(name)
			butt.DoClick = func
			self.FunktionsPanel:Add(butt)
		end
		
	end

	return panel 

end

function ENT:CreateInfoBox(show)

	local panel  = vgui.Create("DPanel")
	
	panel:SetPos(20,20)
	panel:SetSize(120,100)
	panel:SetBackgroundColor(Color(30,0,40,255))
	panel:DockPadding(5,5,5,5)
	panel:DockMargin(5,5,5,5)

	

	local namesP = vgui.Create("DListLayout",panel)
	namesP:Dock(LEFT)
	local valuesP = vgui.Create("DListLayout", panel)
	valuesP:Dock(RIGHT)

	for k,v in pairs(self.resources) do
		local np = vgui.Create("DLabel",namesP)
			np:SetFont("Trebuchet18")
			np:SetText(k)
			namesP:Add(np)
			local vp =vgui.Create("DLabel",valuesP)
			vp:SetText(v)
			vp:SetFont("Trebuchet18")
			valuesP:Add(vp)
			--save pointer to update values
			panel[k]=vp
	end
	namesP:SizeToContents()
	valuesP:SizeToContents()
	panel:SizeToContents()
	panel:SetVisible(show)

	local frac = self
	function panel:UpdateValues()
		--PrintTable(frac.resources)
		for k,v in pairs(frac.resources) do
			self[k]:SetText(v)
		end
	end

	function panel:Think()
		self.LastUpdateTime = self.LastUpdateTime or CurTime()

		if(CurTime()-self.LastUpdateTime > 0.5) then
			self.LastUpdateTime = CurTime()
			self:UpdateValues()
		end

	end

	local frame = vgui.Create("DFrame" )
	frame:Add(panel)
	frame:SetSize(140,100)
	return panel

end

function ENT:ShowInterface(ply)
	if(self.HasInterface == false)then
		self:CreateInterface(ply)
	end

	self:SetGuiVisible(true)
end

function ENT:SetGuiVisible(show)
	--print("AAAAAAAAAAAAAAAAAA")
	for k,v in pairs(self.InterfaceElements) do
		print(k .. ": ")
		print(v)
		v:SetVisible(show)
	end

end

function ENT:SelectUnit(ent)
	
	self:ShowUnitPanel(ent)
	
end

function ENT:UnSelectUnit(ent)
	local unitPanel = self.InterfaceElements["UnitsPanel"]
	unitPanel:SetVisible(false)
end

function ENT:ShowUnitPanel(ent)

	local unitPanel = self.InterfaceElements["UnitsPanel"]
	unitPanel:SetVisible(true)
	unitPanel.InfoBox.NameLabel:SetText(ent:GetName()) 
	unitPanel.InfoBox.HPBar:SetFraction(ent:GetHealthPoints()/ent:GetMaxHealth())
	unitPanel.InfoBox.DescriptionLabel:SetText(ent:GetDescription())
	unitPanel.InfoBox.DescriptionLabel:SizeToContents()
	unitPanel.PortraitBox:SetImage(ent:GetPortrait())
	--unitPanel.PortraitHullPanel:SizeToContentsX() -- doesnt affect
	--unitPanel.PortraitHullPanel:SetSize(100,70) -- does affect

	--unitPanel.PortraitBox:SetKeepAspect(true)
	--unitPanel.PortraitBox:SetSize(60,60)
	unitPanel:SetFunctionsButtons(ent)

	--unitPanel:SetBackgroundColor(Color(0,0,0,200))
	
	--unitPanel:Clear()
end


net.Receive("ShowInterfaceOnClient", function (len)
	local fraction = net.ReadEntity()
	--print(fraction)
	fraction:ShowInterface()
end)


