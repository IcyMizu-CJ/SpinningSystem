local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local UITypes = require(ReplicatedStorage.Shared.UI.UITypes)
local create = vide.create 


return function(props: UITypes.round_button_without_text_props)

    return create 'ImageButton' {
        Size = props.Size or nil,
        LayoutOrder = props.LayoutOrder,

        create 'UICorner' {
            CornerRadius = UDim.new(1),
        },

        create 'UIGradient' {
            Color = props.GradientStroke,
            Rotation = 90,
        },

        create "UIAspectRatioConstraint" {
            AspectRatio = 1
        },

        create "UISizeConstraint" {
            MinSize = Vector2.new(70, 70),
            MaxSize = Vector2.new(180, 180),
        },

        table.unpack(props.Children or {}),

        create 'Frame' {
            Size = UDim2.fromScale(.9, .9),
            AnchorPoint = Vector2.new(.5,.5),
            Position = UDim2.fromScale(.5, .5),
            BackgroundColor3 = props.CircleColor,
            BackgroundTransparency = props.BackgroundTransparency or nil,
            create 'UICorner' {
                CornerRadius = UDim.new(1),
            },

            create 'ImageLabel' {
                AnchorPoint = Vector2.new(0.5,.5),
                Size = UDim2.fromScale(.7, .7),
                Position = UDim2.fromScale(.5, .5),
                Image = props.Icon or nil,
                BackgroundTransparency = 1
            },
        },

        Activated = function()
            if not props.OnClick then
                return
            end 
            props.OnClick()
        end
    }
end