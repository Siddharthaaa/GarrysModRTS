AddCSLuaFile()

local READY = 0
local RUNS = 1
local COMPLETE = 4 

ENT.TaskTimerId = nil
--Hook
function ENT:EndTask(task)


end

--Hook
function ENT:StartTask(task)
	
end



function ENT:AddTask(name, func, args, delay, autostart)
	
	--print("ADDDDD TTTAAAASKK")
	autostart = autostart or false
	
	self.Tasks = self.Tasks or {}
	
	local task = {}
	task.next = autostart
	task.name = name
	task.func = func
	task.args = args  or {}
	
	task.delay = delay or 0
	task.state = READY
	
	table.insert(self.Tasks,task)
	if(#self.Tasks == 1 and autostart) then
		self:NextTask()
	end

end


function ENT:NextTask()


	if(#self.Tasks == 0 or self.Tasks[1].state == RUNS ) then
		--print("BBBBBBBBBBBBBBBBBBBBB")
		return
	end

	if(self.Tasks[1].state == COMPLETE) then
		table.remove(self.Tasks, 1)
	end

	if(#self.Tasks == 0)then
		return
	end

	local task = self.Tasks[1]
	self:StartTask(task)
	task.state=RUNS
	if(task.delay >0) then
		local id = tostring(CurTime()) 
		self.TaskTimerId = id
		print("Creating Timer.. " .. id)
		local tmp =timer.Create(id, task.delay, 1, function()
						print("StartTask: " .. id)
						
						task.func(unpack(task.args))
						self.TaskTimerId = nil
						self:EndTask(task)
						task.state=COMPLETE
						
						if(task.next) then
							self:NextTask()
						end
					end)
		
	else
		task.func(unpack(task.args))
		self:EndTask(task)
		task.state=COMPLETE
		if(task.next) then
			self:NextTask()
		end
	end
	
	

end
