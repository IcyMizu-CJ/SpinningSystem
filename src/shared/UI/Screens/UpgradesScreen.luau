local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local UIState = require(ReplicatedStorage.Shared.UI.States.UIState)
local create = vide.create

local ActiveState = 'Upgrading'

local function UpgradeUI ()

    local visible = vide.derive(function()
        return UIState.ActiveScreen() == ActiveState
    end)

    local Transparency = vide.derive(function()
        if visible() then
            return 0.5 
        else
            return 1
        end
    end)

    return create 'Frame' {
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromScale(0.5,0.5),
        BackgroundTransparency = Transparency,
        Visible = visible,

        create 'Frame' {
            Name = 'Left',
            Size = UDim2.fromScale(0.5, .5),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.fromScale(0,0.5),
            BackgroundTransparency = 0.5,
        },
    }

end


return UpgradeUI