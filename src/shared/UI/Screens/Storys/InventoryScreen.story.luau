local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryScreen = require(script.Parent.Parent.InventoryScreen)
local vide = require(ReplicatedStorage.Packages.vide)

local story = {
    vide = vide,

    story = function()
        vide.cleanup(function()

        end)

        return InventoryScreen
    end,
}

return story