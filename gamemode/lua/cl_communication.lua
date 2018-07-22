AddCSLuaFile()
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
--print(ent)
	net.Start("RemoveEntity")
	--net.WriteString(name)
	net.WriteEntity(ent)
	net.SendToServer()
end

function ExecEntityFunction(ent, index)
	net.Start("ExecFunctionOnEntity")
	net.WriteEntity(ent)
	net.WriteString(index)
	net.SendToServer()
	
end

function ExecEntityFunctionTmp(ent, funcName,opts)
	net.Start("ExecFunctionOnEntityTmp")
	net.WriteEntity(ent)
	net.WriteString(funcName)
	net.WriteTable(opts)
	net.SendToServer()
end