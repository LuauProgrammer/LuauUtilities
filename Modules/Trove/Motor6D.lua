--//Constructs a new Motor6D from the specified parameters.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)

local Motor  = {}

function Motor.new(Part0: BasePart, Part1: BasePart?)
	local self = setmetatable({}, Motor)
	self._trove = Trove.new()

	local Motor6D = self._trove:Construct(Instance.new, "Motor6D")
	Motor6D.Part0 = Part0
	Motor6D.Part1 = Part1
	
	Motor6D.C0 = Part1.CFrame:ToObjectSpace(Part0.CFrame)
	Motor6D.C1 = CFrame.new()
	
	Motor6D.Name = ("Motor6D→%s→%s"):format(Part0.Name, Part1.Name)
	Motor6D.Parent = Part0
	return self
end

function Motor:Destroy()
	self._trove:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return Motor