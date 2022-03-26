--//Basically, creates a 'instance value' from the passed in value.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)

local Value = {}
Value.__index = {
	["Instance"] = "Object",
	["CFrame"] = "CFrame",
	["Vector3"] = "Vector3",
	["string"] = "String",
	["number"] = "Number",
	["boolean"] = "Bool",
	["Color3"] = "Color3",
	["BrickColor"] = "BrickColor",
	["Ray"] = "Ray",
}

function Value.new(InstanceName: string, InstanceParent: Instance, InstanceValue: any?)
	local self = setmetatable({}, Value)
	self._trove = Trove.new()
	
	local Object = self._trove:Construct(Instance.new, Value.__index[typeof(InstanceValue)].."Value")
	Object.Value = InstanceValue
	
	Object.Name = if InstanceName then InstanceName else Object.Name --//incase they passed in nil (bozos)
	Object.Parent = InstanceParent or nil
	return self, Object
end

function Value:Destroy()
	self._trove:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return Value
