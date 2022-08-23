return function (Target)
	return Target and Target.Parent and (Target.Parent:FindFirstChildWhichIsA("Humanoid") or Target.Parent.Parent and Target.Parent.Parent:FindFirstChildWhichIsA("Humanoid"))
end
