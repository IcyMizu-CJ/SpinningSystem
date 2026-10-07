--local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local topbarplus = require(ReplicatedStorage.Packages.topbarplus)
local UIState = require(ReplicatedStorage.Shared.UI.States.UIState)
local Topbar = {}

function Topbar:Init()
	local Icon = topbarplus.new()
	Icon:setImage("rbxassetid://2484556379")
	Icon:setImageScale(0.8)

	--local plr = Players.LocalPlayer

	local db = 1 
	Icon.selected:Connect(function(_fromSource)
		print(UIState.ActiveScreen())
		if db == 1 then
			db = 2
			UIState.ActiveScreen('CoreGui')
		else
			db = 1
			UIState.ActiveScreen('None')
		end
	end)
end

return Topbar
