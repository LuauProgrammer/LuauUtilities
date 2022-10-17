--!strict

type array = {
	[any]: any
}

local SoundUtil: array = {}

local Debris = game:GetService("Debris")

function SoundUtil.FindSoundAndPlay(Instance: Instance,SoundName: string,Recursive: boolean?)
	local Sound: any = Instance:FindFirstChild(SoundName,Recursive)
	if Sound then Sound:Play() end
	return Sound
end

function SoundUtil.CloneSoundAndPlay(Sound: Sound,Parent: Instance?)
	local Clone = Sound:Clone()
	Clone.Parent = Parent or Sound.Parent
	Clone:Play()
	Debris:AddItem(Clone,Sound.TimeLength + 5)
	return Clone
end

return SoundUtil
