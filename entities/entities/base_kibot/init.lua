AddCSLuaFile()
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

--ENT.Model="models/humans/group01/female_01.mdl" 

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Initialize()

self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

	--self:SetModel( "models/player/Group01/Male_02.mdl" )
	--self:SetModel( "models/Combine_Super_Soldier.mdl" )
	--self:SetModel( "models/mossman.mdl" );
	self:SetModel( self.Model );
	--self:SetMoveType(MOVETYPE_STEP )
	
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetHealthPoints(100)
	
	self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	self.Range = 500
	
	
	self:Give("pistol")
	--self:Give("weapon_smg1")

end

function ENT:OnKilled(damage )

	hook.Call( "OnNPCKilled", GAMEMODE, self, damage:GetAttacker(), damage:GetInflictor() )

	local body = ents.Create( "prop_ragdoll" )
	body:SetPos( self:GetPos() )
	body:SetModel( self:GetModel() )
	body:Spawn()

	self:Remove()

	timer.Simple( 100, function()

		body:Remove()

	end )
	
end

function ENT:OnInjured(damage )

	hook.Call( "OnInjured", GAMEMODE, self, damage:GetAttacker(), damage:GetInflictor())
	
	local dmg = damage:GetDamage()
	--print(dmg)
	--print(self:Health())
	self:SetHealth(self:Health()-dmg/10.3)
	--self:SetHealth(70)
	if(self:Health() <=0) then
		--self:Kill()
	end
	self:SetHealthPoints(self:Health())
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	--PrintTable(self:GetSequenceList())
	
end

function ENT:SetEnemy( ent )
	if(ent == self) then return end
	self.Enemy = ent
	if(IsValid(ent)) then
		self.targetPos = nil
	end
end
function ENT:GetEnemy()
	return self.Enemy
end




function ENT:SetTargetPos(vec)
	if(vec != nil) then
		self.targetPos = Vector(vec)
		self.loco:Approach(self.targetPos,1)
		self:SetEnemy(nil)
	else
		self.targetPos = nil
		--self.loco:Approach(self.targetPos,1)
	end

end

function ENT:GetTargetPos()
	return self.targetPos
end

function ENT:BehaveAct()
end

--function ENT:BehaveUpdate( interval ) 
	--print(interval)

--end

----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	self:StartActivity( ACT_IDLE )
	-- This function is called when the entity is first spawned. It acts as a giant loop that will run as long as the NPC exists
	
	
	while(true) do 
		if(self.targetPos !=nil) then
			local dis = self.targetPos:Distance(self:GetPos())
			local tolerance = 70
			if(dis > tolerance) then
				
				local opts = {	lookahead = 300,
							tolerance = tolerance,
							draw = true,
							maxage = 1,
							repath = 0.2	}
				self:StartActivity( ACT_RUN  )	
					
				--self:MoveToPos(self.targetPos,opts)
				self.loco:FaceTowards( self.targetPos )
				self:ChasePos(self.targetPos,opts)
				self:SetTargetPos(nil)
				
				local actList = self:GetSequenceList()
				local index  = math.random(1,#actList)
				local seq = actList[index]
				print("DKFKLSDFKLSDFLKDFJ")
				print(index)
				print(seq)
				--self:PlaySequenceAndWait(seq,1)
				self:StartActivity( ACT_RANGE_ATTACK1  )
				--self:Attack()
				self:StartActivity( ACT_IDLE )
				--self:ChasePos(self.targetPos,opts)
			end
		end
		
		if(self:GetEnemy() and IsValid(self:GetEnemy())) then
			
			self:ChaseEnemy(self:GetEnemy())
			self:StartActivity(ACT_RANGE_ATTACK1 )
			self:StartActivity(ACT_RANGE_AIM_PISTOL_LOW )
			
			self:SetPoseParameter( "aim_yaw", math.Clamp(30, -90, 90)  ) 
		
			self:SetPoseParameter( "aim_pitch", math.Clamp(40, -90, 90) ) 
			coroutine.wait(0.2)
			
			
			self:Attack()
			self:StartActivity(self:GetSequenceActivity(812))
			self:StartActivity(ACT_RANGE_AIM_PISTOL_LOW )
			coroutine.wait(0.1)
		end
		
		coroutine.yield()
	end
	self:StartActivity( ACT_IDLE )

end


function ENT:ChasePos(vec, options)
	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self.targetPos )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end
	
	local dist = self:GetPos():Distance(self.targetPos) 
	
	--self.loco:SetAcceleration( 900 )
	self:StartActivity( ACT_RUN  )
	while ( path:IsValid() and dist > options.tolerance and self.targetPos) do
		dist = self:GetPos():Distance(self.targetPos) 
		--print(dist,options.tolerance)
		if ( path:GetAge() > options.repath or 0.1) then					-- Since we are following the player we have to constantly remake the path
			path:Compute( self,self.targetPos )-- Compute the path towards the enemy's position again
		end
		
		path:Update( self )		-- This function moves the bot along the path
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end
----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
-- except it will constantly follow the
-- position of the enemy until there no longer
-- is one.
----------------------------------------------------
function ENT:ChaseEnemy( options )

	local options = options or {}
	options.maxage= options.maxage or 1

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( self.Range*0.7 or 20 )
	
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end
	self:StartActivity( ACT_RUN  )
	while ( path:IsValid() and IsValid(self:GetEnemy()) and self:GetRangeTo(self:GetEnemy()) > self.Range*0.7 )do

		if ( path:GetAge() > options.maxage ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute( self, self:GetEnemy():GetPos() )-- Compute the path towards the enemy's position again
		end
		path:Update( self )								-- This function moves the bot along the path

		if ( options.draw ) then path:Draw() end
		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:Give(swep_name)
	local swep = ents.Create(swep_name)
	
	local handPos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
	
	if(!IsValid(swep)) then return false end
	

	
	swep:SetMoveType( MOVETYPE_NONE ) 
	
	swep:Spawn()
	
	swep:SetSolid(SOLID_NONE) --collision stuff
	swep:SetParent(self)
	
	swep:Fire("setparentattachment", "anim_attachment_RH") -- binds the weapon to the attachment of its parent
	swep:AddEffects(EF_BONEMERGE)
	--local pos = self:EyePos()
	--swep:SetPos(pos)
	--swep:SetAngles(self:GetAngles())
	swep:SetOwner(self)
	self:SetWeapon( swep)
	self.Weapon = swep
	

end

function ENT:HasWeapon()
	return IsValid(self:GetWeapon())
end

function ENT:Attack()
	if(self:HasWeapon()) then
		self:GetWeapon():PrimaryAttack()
	end
end





list.Set( "NPC", "simple_nextbot", {
	Name = "Simple bot",
	Class = "base_kibot",
	Category = "NextBot"
} )