SWEP.PrintName 		= "Killa_Pistol" // The name of your SWEP 
 
SWEP.Author 		= "yaddablahdah" // Your name 
SWEP.Instructions 	= "SwepInstructions" // How do people use your SWEP? 
SWEP.Contact 		= "YourMailAdress" // How people should contact you if they find bugs, errors, etc 
SWEP.Purpose 		= "WhatsThePurposeOfThisSwep" // What is the purpose of the SWEP? 
 
SWEP.AdminSpawnable = true // Is the SWEP spawnable for admins? 
SWEP.Spawnable 		= true // Can everybody spawn this SWEP? - If you want only admins to spawn it, keep this false and admin spawnable true. 
 
SWEP.ViewModelFOV 	= 64 // How much of the weapon do you see? 
SWEP.ViewModel 		= "models/weapons/v_pistol.mdl" // The viewModel = the model you see when you're holding the weapon.
SWEP.WorldModel 	= "models/weapons/w_pistol.mdl" // The world model = the model you when it's down on the ground.
 
SWEP.AutoSwitchTo 	= false // When someone picks up the SWEP, should it automatically change to your SWEP? 
SWEP.AutoSwitchFrom = true // Should the weapon change to the a different SWEP if another SWEP is picked up?
 
SWEP.Slot 			= 1 // Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 1 // Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6) 
 
SWEP.HoldType = "Pistol" // How is the SWEP held? (Pistol SMG Grenade Melee) 
 
SWEP.FiresUnderwater = true // Does your SWEP fire under water?
 
SWEP.Weight = 5 // Set the weight of your SWEP. 
 
SWEP.DrawCrosshair = true // Do you want the SWEP to have a crosshair? 
 
SWEP.Category = "Biobastards" // Which weapon spawning category do you want your SWEP to be in?
 
SWEP.DrawAmmo = true // Does the ammo show up when you are using it? True / False 
 
SWEP.ReloadSound = "sound/owningyou.wav" // Reload sound, you can use the default ones, or you can use your own; Example; "sound/myswepreload.wav" 
 
SWEP.base = "weapon_pistol" //What your weapon is based on.
//General settings\\
 
//PrimaryFire Settings\\ 
SWEP.Primary.Sound = "sound/seeya.wav" // The sound that plays when you shoot your SWEP :-] 
SWEP.Primary.Damage = 4 // How much damage the SWEP will do.
SWEP.Primary.TakeAmmo = 1 // How much ammo does the SWEP use each time you shoot?
SWEP.Primary.ClipSize = 10 // The clip size.
SWEP.Primary.Ammo = "Pistol" // The ammo used by the SWEP. (pistol/smg1) 
SWEP.Primary.DefaultClip = 10 // How much ammo do you get when you first pick up the SWEP? 
SWEP.Primary.Spread = 0.5 // Do the bullets spread all over when firing? If you want it to shoot exactly where you are aiming, leave it at 0.1 
SWEP.Primary.NumberofShots = 1 // How many bullets the SWEP fires each time you shoot. 
SWEP.Primary.Automatic = true // Is the SWEP automatic?
SWEP.Primary.Recoil = 10 // How much recoil does the weapon have?
SWEP.Primary.Delay = 0.2 // How long must you wait before you can fire again?
SWEP.Primary.Force = 1000 // The force of the shot.
SWEP.Primary.TracerName = "AR2Tracer"
SWEP.Primary.Distance = 56756

// Tracer Names/*
--AR2Tracer - Self-descripting. Visible from all directions except under it
--AirboatGunHeavyTracer - Makes a bigger version of the Pulse-rifle Tracer.
--AirboatGunTracer - Similar to the Pulse-rifle Tracer, only visible from above. 
--Tracer - 9mm pistol tracer
--StriderTracer - Similar to AR2 tracer
--HelicopterTracer - Similar to GunshipTracer effect
--GunshipTracer - 2x the size of the pulse-rifle tracer
--LaserTracer - The tool tracer effect from the Tool Gun

//PrimaryFire settings\\
 
//Secondary Fire Variables\\ 
SWEP.Secondary.NumberofShots = 1 // How many explosions for each shot.
SWEP.Secondary.Force = 1000 // The force of the explosion.
SWEP.Secondary.Spread = 0.1 // How much of an area does the explosion affect? 
SWEP.Secondary.Sound = "sound/ultrakill.wav" // The sound that is made when you shoot.
SWEP.Secondary.DefaultClip = 100 // How much secondary ammo does the SWEP come with?
SWEP.Secondary.Automatic = false // Is it automactic? 
SWEP.Secondary.Ammo = "Pistol" // Leave as Pistol! 
SWEP.Secondary.Recoil = 10 // How much recoil does the secondary fire have?
SWEP.Secondary.Delay = 3 // How long you have to wait before firing another shot?
SWEP.Secondary.TakeAmmo = 1 // How much ammo does each shot take?
SWEP.Secondary.ClipSize = 100 // The size of the clip for the secondary ammo.
SWEP.Secondary.Damage = 1 // The damage the explosion does. 
SWEP.Secondary.Magnitude = "175" // How big is the explosion ? 
//Secondary Fire Variables\\
 
//SWEP:Initialize\\ 
function SWEP:Initialize() //Tells the script what to do when the player "Initializes" the SWEP.
	util.PrecacheSound(self.Primary.Sound) 
	util.PrecacheSound(self.Secondary.Sound) 
        self:SetWeaponHoldType( self.HoldType )
end 
//SWEP:Initialize\\

function SWEP:GetCapabilities()

	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )

end
 
//SWEP:PrimaryFire\\ 
function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
--print(self:IsWeapon())
	--local muzzle = self:LookupAttachment("muzzle")
	--local obj = self:GetAttachment(muzzle)
	
	local dir, scr
	
	if self.Owner:IsPlayer() then
		dir = self.Owner:GetAimVector()
		scr = self.Owner:GetShootPos()		
	else
		
		dir = self.Owner:GetAimVector()
		scr = self.Owner:GetShootPos()		
		--scr = self:GetPos()
	end
	
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		--bullet.Num = 10//The number of shots fired
		bullet.Src = scr --Gets where the bullet comes from
		bullet.Dir = dir --Gets where you're aiming
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = 1
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.TracerName = self.Primary.TracerName
		bullet.HullSize =1
		bullet.Distance= self.Owner.Range
		bullet.IgnoreEntity = Entity(1)
		
		--print(bullet.Src)
		--print(bullet.Dir)
 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
 
	self:ShootEffects()
 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(Sound(self.Primary.Sound)) 
	--self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	
	--print(CurTime())
	--print(CurTime() + self.Primary.Delay )
end 
//SWEP:PrimaryFire\\
 
//SWEP:SecondaryFire\\ 
function SWEP:SecondaryAttack() 
	if ( !self:CanSecondaryAttack() ) then return end 
	
	local rnda = -self.Secondary.Recoil 
	local rndb = self.Secondary.Recoil * math.random(-1, 1) 
 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) //Makes the gun have recoil
        //Don't change self.Owner:ViewPunch() if you don't know what you are doing.
 
	local eyetrace = self.Owner:GetEyeTrace()
	self:EmitSound ( self.Secondary.Sound ) //Adds sound
	self:ShootEffects() 
	local explode = ents.Create("env_explosion")
		explode:SetPos( eyetrace.HitPos ) //Puts the explosion where you are aiming
		explode:SetOwner( self.Owner ) //Sets the owner of the explosion
		explode:Spawn()
		explode:SetKeyValue("iMagnitude","175") //Sets the magnitude of the explosion
		explode:Fire("Explode", 0, 0 ) //Tells the explode entity to explode
		explode:EmitSound("weapon_AWP.Single", 400, 400 ) //Adds sound to the explosion
 
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay ) 
	
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
	self:TakePrimaryAmmo(self.Secondary.TakeAmmo) 
end 

function SWEP:CanPrimaryAttack()
	--print(self:GetNextPrimaryFire())
	if(self:GetNextPrimaryFire() > CurTime()) then return false end
--print(self:Clip1())
	if ( self:Clip1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 1 )
		local owner = self:GetOwner()
		if( owner.StartActivity != nil) then
			self:GetOwner():StartActivity( ACT_RELOAD_PISTOL)
		end
		self:Reload()
		self:SetClip1(self.Primary.ClipSize)
		coroutine.wait(0.3)
		return false

	end

	return true

end