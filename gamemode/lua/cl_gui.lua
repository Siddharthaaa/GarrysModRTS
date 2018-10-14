AddCSLuaFile()

posFirstClick = {0,0}

--at the cursor appended model and funcion
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
		
		--DrawHealthBars()
		ShowPlayerInfos()
		

	end
)

hook.Add("PlayerButtonDown","GroupsSelection",function(ply,button)

	--print("TETEEETETETSTSTSTSTSTSTTTTTT")
	if(button >= KEY_1 && button <=KEY_9) then
		if(input.IsControlDown())then
			ply:GetFraction():SetUnitGroup(button)
		else
			ply:GetFraction():SelectUnitGroup(button)
		end
			
	end


end)


function ShowPlayerInfos()
	
	surface.SetFont("Trebuchet24")
	
	local ply = LocalPlayer()
	
	--[[surface.SetTextColor( 0,222,50)
	surface.SetTextPos( 50, 30 )
	surface.DrawText( "Gold: " .. ply:GetNWInt("Gold"))
	]]
	
	--surface.DrawOutlinedRect(100,100,200,200)
	
	
	
end

-- is not in use
function DrawHealthBars()
		local selectedEntities = LocalPlayer():GetFraction():GetSelectedEnts()
		if(#selectedEntities>0) then
		for k,v in pairs(selectedEntities) do
			if(IsValid(v) and v.GetHealthPoints != nil) then
				local vec = v:GetPos()
				local pos = vec:ToScreen()
				
				local w = 100;
				local h = 10
				
				local x1
				x1 = w* (v:GetHealthPoints() / v:GetMaxHealth())
				
				--print(v:Health())
				surface.SetDrawColor(10,222,30)
				surface.DrawRect(pos.x,pos.y,x1,h)
				surface.SetDrawColor(200,2,30)
				surface.DrawRect(pos.x +x1,pos.y,w-x1,h)
				
				--Weapon position
				
				local pos = v:GetShootPos():ToScreen()
				
				surface.DrawRect(pos.x,pos.y,20,20)
			end	
			
		end
		end

end

function GetSelectBoxCoordinates()
	if(posFirstClick == nil) then
		return 0,0,0,0
	end

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
		local tr = util.QuickTrace( LocalPlayer():GetShootPos(), gui.ScreenToVector( gui.MousePos() )*100000, LocalPlayer() )
		--print( tr.HitPos )
		appendedModel:SetPos(tr.HitPos)
	end
end)

hook.Add("VGUIMousePressed","clean_bugs",function(pnl, mousecode)
	posFirstClick=nil
	
end)


hook.Add("GUIMousePressed","gui_mouse_pressed_select_ent",function(key,vector)
			local selectedEntities = LocalPlayer():GetFraction():GetSelectedEnts()
			--Give a Order to the Selected Entitys
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
								ExecEntityFunctionTmp(v,"SetTargetPos",{tr.HitPos,input.IsKeyDown(KEY_LCONTROL)})
								--ExecEntityFunctionTmp(v,"SetEnemy",{nil})
								
						end
					end
						
				end
			end 
			--
			if (key == MOUSE_LEFT) then
				
				posFirstClick = {gui.MousePos()}
				local ent = GetEntityOnMouse()
				if(ent !=nil) then
					ent:Select(input.IsShiftDown())
				else
					if(!input.IsShiftDown()) then
						LocalPlayer():GetFraction():UnSelectAllUnits()
					end
				end
				--print(input.IsShiftDown())
					
			else
				
			end
			
		end
)
	


function GetEntityOnMouse()
	local tr = util.QuickTrace( LocalPlayer():GetShootPos(), gui.ScreenToVector( gui.MousePos() )*1000000, LocalPlayer() )
			--PrintTable(tr)
	if(IsValid(tr.Entity)) then
	--print(tr.Entity)
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
				
				--posSecClick = {gui.MousePos()}
				
				
				x1,y1,x2,y2 = GetSelectBoxCoordinates()
				if(x2-x1 < 10 or y2-y1 <10) then 
					
					--LocalPlayer():GetFraction():UnSelectAllUnits()
					return
				end
				print(x1,x2,y1,y2)
				if(! input.IsShiftDown()) then 
					LocalPlayer():GetFraction():UnSelectAllUnits()
				end
				
				for k,v in pairs(ents.GetAll()) do 
					if(v.IsSelectable != nil and v.IsSelectable()) then
						
						-- does not work here
						-- must be done in 3D rendering context
						--point= v:GetPos():ToScreen()
						
						
						local vDir=v:GetPos() - LocalPlayer():EyePos()

						x,y,vis = VectorToLPCameraScreen(vDir,ScrW(),ScrH(),LocalPlayer():EyeAngles(),LocalPlayer():GetFOV()/180*3,1415 )

						print(x,y)
						
						--print(v)
						if(x>x1 and x<x2 and y>y1 and y<y2) then
							v:Select(true)
						end
					end
					
				end
				
				posFirstClick = nil
		end
	end
)

function getElemIndexInTable(tab, element)
	for pos, v in pairs(tab) do 
		if v == element then
			return pos
		end
	end

end



function appendEntOnMouse(entName, func)
	removeEntOnMouse()
	local tmpEnt = scripted_ents.Get( entName )
	--PrintTable(tmpEnt)
		for k,v in pairs (scripted_ents.GetList()) do
			--PrintTable(v)
		end
	appendedModel = ClientsideModel( tmpEnt.Model,RENDERGROUP_OPAQUE  )
	appendedModel:SetColor(40,40,200,100)
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

-- old gui

--[[

panel = vgui.Create("DPanel")


panel:SetVisible(true)
panel:SetSize(600,100)
panel:SetPos(400,ScrH()-120)
panel:SetBackgroundColor(Color(120,120,120,120))
--panel:SetCols(6)

--panel:SetColor(Color(120,120,120))
--panel:MakePopup()

optionsGrid = vgui.Create("DGrid",panel)
optionsGrid:SetCols(6)
optionsGrid:SetRowHeight(50)
optionsGrid:SetColWide(50)

setDefaultOptions()

--NEW GUI

--]]


--[[
Give this function the coordinates of a pixel on your screen, and it will return a unit vector pointing
in the direction that the camera would project that pixel in.
 
Useful for converting mouse positions to aim vectors for traces.
 
iScreenX is the x position of your cursor on the screen, in pixels.
iScreenY is the y position of your cursor on the screen, in pixels.
iScreenW is the width of the screen, in pixels.
iScreenH is the height of the screen, in pixels.
angCamRot is the angle your camera is at
fFoV is the Field of View (FOV) of your camera in ___radians___
	Note: This must be nonzero or you will get a divide by zero error.
 ]]--
 function LPCameraScreenToVector( iScreenX, iScreenY, iScreenW, iScreenH, angCamRot, fFoV )
    --This code works by basically treating the camera like a frustrum of a pyramid.
    --We slice this frustrum at a distance "d" from the camera, where the slice will be a rectangle whose width equals the "4:3" width corresponding to the given screen height.
    local d = 4 * iScreenH / ( 6 * math.tan( 0.5 * fFoV ) )	;
 
    --Forward, right, and up vectors (need these to convert from local to world coordinates
    local vForward = angCamRot:Forward();
    local vRight   = angCamRot:Right();
    local vUp      = angCamRot:Up();
 
    --Then convert vec to proper world coordinates and return it 
    return ( d * vForward + ( iScreenX - 0.5 * iScreenW ) * vRight + ( 0.5 * iScreenH - iScreenY ) * vUp ):Normalize();
end
 
--[[
Give this function a vector, pointing from the camera to a position in the world,
and it will return the coordinates of a pixel on your screen - this is where the world position would be projected onto your screen.
 
Useful for finding where things in the world are on your screen (if they are at all).
 
vDir is a direction vector pointing from the camera to a position in the world
iScreenW is the width of the screen, in pixels.
iScreenH is the height of the screen, in pixels.
angCamRot is the angle your camera is at
fFoV is the Field of View (FOV) of your camera in ___radians___
	Note: This must be nonzero or you will get a divide by zero error.
 
Returns x, y, iVisibility.
	x and y are screen coordinates.
	iVisibility will be:
		1 if the point is visible
		0 if the point is in front of the camera, but is not visible
		-1 if the point is behind the camera
]]--
function VectorToLPCameraScreen( vDir, iScreenW, iScreenH, angCamRot, fFoV )
	--Same as we did above, we found distance the camera to a rectangular slice of the camera's frustrum, whose width equals the "4:3" width corresponding to the given screen height.
	local d = 4 * iScreenH / ( 6 * math.tan( 0.5 * fFoV ) );
	local fdp = angCamRot:Forward():Dot( vDir );
 
	--fdp must be nonzero ( in other words, vDir must not be perpendicular to angCamRot:Forward() )
	--or we will get a divide by zero error when calculating vProj below.
	if fdp == 0 then
		return 0, 0, -1
	end
 
	--Using linear projection, project this vector onto the plane of the slice
	local vProj = ( d / fdp ) * vDir;
 
	--Dotting the projected vector onto the right and up vectors gives us screen positions relative to the center of the screen.
	--We add half-widths / half-heights to these coordinates to give us screen positions relative to the upper-left corner of the screen.
	--We have to subtract from the "up" instead of adding, since screen coordinates decrease as they go upwards.
	local x = 0.5 * iScreenW + angCamRot:Right():Dot( vProj );
	local y = 0.5 * iScreenH - angCamRot:Up():Dot( vProj );
 
	--Lastly we have to ensure these screen positions are actually on the screen.
	local iVisibility
	if fdp < 0 then			--Simple check to see if the object is in front of the camera
		iVisibility = -1;
	elseif x < 0 || x > iScreenW || y < 0 || y > iScreenH then	--We've already determined the object is in front of us, but it may be lurking just outside our field of vision.
		iVisibility = 0;
	else
		iVisibility = 1;
	end
 
	return x, y, iVisibility;
end
