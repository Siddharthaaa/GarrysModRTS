--AddCSLuaFile()


ENT.TaskTimerId = nil
--Hook
function ENT:EndTask(task)


end

--Hook
function ENT:StartTask(task)
	
end



function ENT:AddTask(name, func, args, delay, autostart)
	
	autostart = autostart or false
	
	self.Tasks = self.Tasks or {}

	local task = {}
	task.name = name
	task.func = func
	task.args = args  or {}
	
	task.delay = delay or 0
	


	table.insert(self.Tasks,task)
	if(#self.Tasks == 1 and autostart) then
		self:NextTask()
	end

end

--internal function
function ENT:NextTask()
	if(#self.Tasks == 0) then return end
	local task = self.Tasks[1]
	if(task.delay >0) then
		local id = tostring(CurTime()) 
		self.TaskTimerId = id
		print("Creating Timer.. " .. id)
		local tmp =timer.Create(id, task.delay, 1, function()
						print("StartTask: " .. id)
						self:StartTask(task)
						task.func(unpack(task.args))
						table.remove(self.Tasks,1)
						self:EndTask(task)
						self.TaskTimerId = nil
						self:NextTask()
					end)
		
	else
		task.func(unpack(task.args))
	end

end
