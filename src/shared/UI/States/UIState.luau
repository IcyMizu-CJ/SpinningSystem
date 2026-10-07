local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local UITypes = require(ReplicatedStorage.Shared.UI.UITypes)


local UIState = {}

local activeScreenInitial: UITypes.screen_name = 'CoreGui'
UIState.ActiveScreen = vide.source(activeScreenInitial)
-- CoreGui,Spinning,Upgrading

return UIState