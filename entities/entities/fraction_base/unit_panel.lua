-- First, we define a table to store our control in
local PANEL={}
 
-- This is called when the control is created
-- via vgui.Create
function PANEL:Init()
end
 
-- This function is called whenever we need to paint the control
-- ( This is where we define what it looks like. )
function PANEL:Paint()
  -- This draws a round black box as the background for this control
  draw.RoundedBox(6,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,255));
 
  return true; -- Since we are deriving this from another class, we don't want the renderer to call the OnPaint() function of the class that we derived this from.
end
 
-- This function is called whenever this control is pressed
function PANEL:OnMousePressed()
  Msg( "Hello, world!\n" );
end
 
-- Register the new control so that we can use it by doing vgui.Create("panel_example");
vgui.Register( "panel_example", PANEL );
 