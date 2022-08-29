--//Welds two parts together, yeah.
--//i kinda helped @LuaRook with this. (not really!)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)

local Weld = {}

function Weld.new(Model: Model, PrimaryPart: BasePart?)
	local self = setmetatable({}, Weld)
	self._trove = Trove.new()
	self.Model = Model
	self.PrimaryPart = if PrimaryPart then PrimaryPart else self.Model.PrimaryPart
	self.PrimaryPart.Anchored = true
	self.PrimaryPart.CanCollide = false
	
	for _,Part: BasePart in ipairs(self.Model:GetDescendants()) do
		if Part ~= self.PrimaryPart and Part:IsA("BasePart") then
			local constraint = self._trove:Construct(Instance.new, "WeldConstraint")
			constraint.Part0 = Part
			constraint.Part1 = self.PrimaryPart
			
			constraint.Name = ("Weld→%s→%s"):format(Part.Name, self.PrimaryPart.Name)
			constraint.Parent = Part
			
			Part.Anchored = false
			Part.CanCollide = true
		end
	end
	return self
end

function Weld:Destroy()
	self._trove:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return Weld
