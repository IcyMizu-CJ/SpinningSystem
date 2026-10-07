local SoundManager = {}

function SoundManager:Init(_Services)
	self.SoundsFolder = game:GetService("SoundService").Sounds
end

function SoundManager:PlaySound(SoundName: string)
	local sound = self.SoundsFolder:FindFirstChild(SoundName)
	if not sound then
		warn(`Sound {SoundName} not found in Sounds folder`)
		return
	end

	sound:Play()
end

return SoundManager
