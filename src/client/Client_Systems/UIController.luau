local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local CoreGuiScreen = require(ReplicatedStorage.Shared.UI.Screens.CoreGuiScreen)
local SpinningGuiScreen = require(ReplicatedStorage.Shared.UI.Screens.SpinningGuiScreen)
local UpgradesScreen = require(ReplicatedStorage.Shared.UI.Screens.UpgradesScreen)
local create = vide.create
local UIController = {}

local function MountUi(Name: string,plrgui: PlayerGui,Cb: () -> ())
    vide.mount(function()
        return create 'ScreenGui' {
            Name = Name,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            Enabled = true,

            Cb()
        }
    end, plrgui)

end

function UIController:Init()
    local plrgui = Players.LocalPlayer:WaitForChild('PlayerGui')
    MountUi('CoreGui',plrgui,CoreGuiScreen)
    MountUi('SpinningGui',plrgui,SpinningGuiScreen)
    MountUi('UpgradingGui',plrgui,UpgradesScreen)
    
end

return UIController