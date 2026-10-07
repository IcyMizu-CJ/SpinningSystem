local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradesScreen = require(script.Parent.Parent.UpgradesScreen)
local vide = require(ReplicatedStorage.Packages.vide)
local story = {
    vide = vide,

    story = function()
        vide.cleanup(function()

        end)

        return UpgradesScreen
    end
}

return story