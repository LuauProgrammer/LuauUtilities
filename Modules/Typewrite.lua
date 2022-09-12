--!strict

local function PlayTypewriterSound()
	if not script:FindFirstChild("Click") then return end
	local Clone: Sound = script.Click:Clone()
	Clone.PlayOnRemove = true
	Clone.Parent = script
	Clone:Destroy()
end

return function(String: string, Label: TextLabel, Interval: number?)
	for Character: number = 1, String:len() do
		Label.Text = Label.Text..String:sub(Character,Character)
		PlayTypewriterSound()
		task.wait(Interval or 0.04)
	end
end
