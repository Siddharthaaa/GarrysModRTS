include( "shared.lua" )

gui.EnableScreenClicker( true ) 


local panel = vgui.Create("DPanel")

panel:SetVisible(true)
panel:SetSize(600,100)
panel:SetPos(20,ScrH()-120)
--panel:SetColor(Color(120,120,120))
--panel:MakePopup()

local ButtCreateEnt = vgui.Create("DButton",panel)

ButtCreateEnt:SetSize(80,80)
ButtCreateEnt:SetText("Gebäude \nbauen")

ButtCreateEnt.DoClick = function()
	net.Start("CreateEntity")
	net.WriteString("testent")
	net.SendToServer()
	
end

net.Receive("Clicker_off",function(len)
	gui.EnableScreenClicker( false )

end)

net.Receive("Clicker_on",function(len)
	gui.EnableScreenClicker( true )

end)