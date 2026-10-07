local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGuiScreen = require(script.Parent.Parent.CoreGuiScreen)
local vide = require(ReplicatedStorage.Packages.vide)
local UIState = require(ReplicatedStorage.Shared.UI.States.UIState)

local story = {
	vide = vide,
	story = function()
		vide.cleanup(function()
		end)

		UIState.ActiveScreen('CoreGui')

		return CoreGuiScreen()
	end,
}

return story
