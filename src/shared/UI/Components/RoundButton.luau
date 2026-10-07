local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local ColorConfig = require(ReplicatedStorage.Shared.UI.ColorConfig)
local UITypes = require(ReplicatedStorage.Shared.UI.UITypes)
local create = vide.create
local source = vide.source

local function RoundButton(props: UITypes.round_button_props)
    local hovered = source(false)

    local Scale = vide.derive(function()  
        return vide.read(hovered) and 1.1 or 1
    end)

    return create 'ImageButton' {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = props.Size or UDim2.fromScale(0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundTransparency = props.BackgroundTransparency or 0,
            LayoutOrder = props.LayoutOrder or 0,

            MouseEnter = function()
                hovered(true)
            end,

            MouseLeave = function()
                hovered(false)
            end,

            Activated = function()
                props.OnClick()
            end,

            create 'UIScale' {
                Scale = vide.spring(Scale,.3)
            },

            create "UIAspectRatioConstraint" {
                AspectRatio = 1
            },

            create "UISizeConstraint" {
                MinSize = Vector2.new(70, 70),
                MaxSize = Vector2.new(200, 200),
            },

            create 'UICorner' {
                CornerRadius = UDim.new(1)
            },

            create 'UIGradient' {
                Color = props.GradientColor1 or Color3.new(),
                Rotation = 90
            },

                create 'Frame' {
                    Size = UDim2.fromScale(.95, .95),
                    AnchorPoint = Vector2.new(0.5,0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    BackgroundColor3 = props.CircleColor1 or Color3.new(),
                    ClipsDescendants = true,
                    
                    create 'UICorner' {
                        CornerRadius = UDim.new(1)
                    },
                    unpack(props.Children or {}),
                    
                },
                
                

                create 'TextLabel' {
                    Text = props.Text or 'No Text',
                    Size = UDim2.fromScale(2, 2),
                    AnchorPoint = Vector2.new(0.5,.5),
                    Position = UDim2.fromScale(0.5,0.9),
                    TextScaled = true,
                    BackgroundTransparency = 1,
                    TextColor3 =  Color3.new(1, 1, 1),
                    FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,


                    create 'UITextSizeConstraint' {
                        props.TextSizeConstraint or {}
                    },

                    create 'UIGradient' {
                        Color = ColorConfig.RollTextGradient,
                        Rotation = 90
                    },

                    ZIndex = 2
                },

                create 'TextLabel' {
                    Text = props.Text or 'No Text',
                    Size = UDim2.fromScale(2, 2),
                    AnchorPoint = Vector2.new(0.5,.5),
                    Position = UDim2.fromScale(0.5,0.92),
                    TextScaled = true,
                    BackgroundTransparency = 1,
                    TextColor3 =  Color3.new(1, 1, 1),
                    FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,


                    create 'UITextSizeConstraint' {
                        props.TextSizeConstraint or {}
                    },

                    create 'UIGradient' {
                        Color = props.TextGradient or ColorSequence.new(Color3.new()),
                        Rotation = 90
                    },

                    create 'UIStroke' {
                        Thickness = 3,
                        Color = Color3.new(1, 1, 1)
                    },
                }
            
    }
end

return RoundButton