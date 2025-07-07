--[[
	Author: Quintinite
	Date: 9/11/22
	Script: Collector
]]

--//Services

local CollectionService = game:GetService("CollectionService")

--//Tables

local Collector = {
	Collected = {}
}

--//Main

function Collector:Collect(Directory)
	for _,Instance in ipairs(Directory:GetChildren()) do
		if Instance:IsA("ModuleScript") then
			assert(not self.Collected[Instance.Name],"Expected one module for the tag "..Instance.Name..", got two.") --//prevent duplicate tags
			local Module = require(Instance)
			for _,Object in ipairs(CollectionService:GetTagged(Instance.Name)) do
				task.spawn(Module.Added,Object)
			end

			self.Collected[Instance.Name] = {}
			self.Collected[Instance.Name].Added = CollectionService:GetInstanceAddedSignal(Instance.Name):Connect(Module.Added)
			self.Collected[Instance.Name].Removed = CollectionService:GetInstanceRemovedSignal(Instance.Name):Connect(Module.Removed)
		else
			self:Collect(Instance) --//if not a module script, recurse
		end
	end
end

return Collector
