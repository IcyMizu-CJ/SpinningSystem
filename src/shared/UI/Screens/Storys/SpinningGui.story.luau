local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpinningGuiScreen = require(script.Parent.Parent.SpinningGuiScreen)
local vide = require(ReplicatedStorage.Packages.vide)
local story = {
    vide = vide,

    story = function()
        vide.cleanup(function() 
        
        end)

        return SpinningGuiScreen({Preview = true})

    end
}

return story