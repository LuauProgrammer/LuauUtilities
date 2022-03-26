--//A scuffed module that creates a tween & then cleans it up, even though Lua will garbage collect it.

local TweenService = game:GetService("TweenService")

local function SimpleTween(Instance: Instance, Info: TweenInfo, Table: any, Wait: Number?) 
	local UnpackedInfo = table.unpack(Info) --//unpack as info should be a table
	local Tween = TweenService:Create(Instance,TweenInfo.new(UnpackedInfo),Table)
	Tween:Play()
	if Wait then 
		Tween.Completed:Wait()
		Tween:Destroy()
		return Enum.PlaybackState.Completed
	else
		task.spawn(function()
			Tween.Completed:Wait()
			Tween:Destroy()
			return Enum.PlaybackState.Completed
		end)
	end
end


return SimpleTween
