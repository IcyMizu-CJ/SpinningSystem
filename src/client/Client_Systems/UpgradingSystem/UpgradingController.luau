local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradingSignals = require(ReplicatedStorage.Shared.Systems.UpgradingSystem.UpgradingSignals)
local UIState = require(ReplicatedStorage.Shared.UI.States.UIState)
local UpgradingController = {}


function UpgradingController:Init()
    
    UpgradingSignals.OnClick:Connect(function()
        UIState.ActiveScreen('Upgrading')
    end)



end


return UpgradingController