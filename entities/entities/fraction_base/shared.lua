ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName ="Fraktion_Human"

ENT.Spawnable = false

ENT.resources = {Gold=1000,Wood=1000,Iron=1000}

function ENT:GetResources()

	return self.resources
end

