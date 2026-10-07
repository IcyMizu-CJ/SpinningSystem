local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local RollSignals = require(ReplicatedStorage.Shared.Systems.RollSystem.RollSignals)
local UpgradingSignals = require(ReplicatedStorage.Shared.Systems.UpgradingSystem.UpgradingSignals)
local ColorConfig = require(ReplicatedStorage.Shared.UI.ColorConfig)

--Components
local RoundButton = require(ReplicatedStorage.Shared.UI.Components.RoundButton)
local Icons = require(ReplicatedStorage.Shared.UI.Icons)
local PlayerConfigState = require(ReplicatedStorage.Shared.UI.States.PlayerConfigState)
local UIState = require(ReplicatedStorage.Shared.UI.States.UIState)
local UseAnimatedValue = require(ReplicatedStorage.Shared.Utility.UseAnimatedValue)

--Types
local create = vide.create

local function CoreGui ()

    local visible = vide.derive(function()
        return UIState.ActiveScreen() == 'CoreGui'
    end)
    
    local bottom_target = UseAnimatedValue({
        when = visible, 
        on = UDim2.fromScale(.5, 1),
        off = UDim2.fromScale(.5, 2)
    })

    return create 'Frame' {
        Name = 'Root',
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5,.5),
        BackgroundTransparency = 1,

        create 'Frame' {
            Name = 'Bottom',
            AnchorPoint = Vector2.new(0.5,1),
            Size = UDim2.fromScale(1, 0.3),
            Position = bottom_target,
            BackgroundTransparency = 1,

            create 'UIListLayout' {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.02)
            },

            --// ROLL BUTTON
            RoundButton({
                Size = UDim2.fromScale(0.21,1),
                LayoutOrder = 2,
                CircleColor1 = ColorConfig.MainColor,
                StrokeColor2 = ColorConfig.MainAccentColor,
                GradientColor1 = ColorConfig.LightToDarkPurpleGradient,
                StrokeColor = Color3.new(),
                Icon = Icons.Dice,Text = 'ROLL',
                TextStrokeColor = ColorConfig.MainAccentColor,
                TextColor = ColorConfig.MainColor,
                GlowColor = ColorConfig.BluePurplish,
                TextGradient = ColorConfig.LightToDarkPurpleGradient,
                OnClick = function() 
                    UIState.ActiveScreen('Spinning')
                    if vide.read(PlayerConfigState.AutoRoll) == false then
                        RollSignals.OnClick:Fire()
                    end
                end,
                Children = {
                    create 'ImageLabel' {
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = Icons.CircleTexture,
                        ImageColor3 = ColorConfig.MainAccentColor,
                        ImageTransparency = 0.8 ,
                        ZIndex = 0  
                    },
                    create 'ImageLabel' {
                        Image = Icons.Dice or '',
                        Size = UDim2.fromScale(1, 1),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5,0.5),
                        BackgroundTransparency = 1,
                        ScaleType = Enum.ScaleType.Crop,
                        ZIndex = 4,
                    },
                },
                TextSizeConstraint = {
                    MinTextSize = 60,
                    MaxTextSize = 65,
                },
            }),
            --// UPGRADE BUTTON
            RoundButton({
                Size = UDim2.fromScale(0.11,1),
                LayoutOrder = 1,
                CircleColor1 = ColorConfig.MainColor,
                StrokeColor2 = ColorConfig.BlueAccentColor,
                GradientColor1 = ColorConfig.LightToDarkBlueGradient,
                StrokeColor = Color3.new(),
                Text = 'UPGRADE',
                TextStrokeColor = ColorConfig.BlueAccentColor,
                TextColor = ColorConfig.MainColor,
                TextGradient = ColorConfig.LightToDarkBlueGradient,
                OnClick = function() 
                    UpgradingSignals.OnClick:Fire()
                end,
                Children = {
                    create 'ImageLabel' {
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = Icons.CircleTexture,
                        ImageColor3 = ColorConfig.BlueAccentColor,
                        ImageTransparency = 0.8 ,
                        ZIndex = 0  
                    },
                    create 'ImageLabel' {
                        Image = Icons.UpgradeLogo or '',
                        Size = UDim2.fromScale(1, 1),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5,0.5),
                        BackgroundTransparency = 1,
                        ScaleType = Enum.ScaleType.Crop,
                        ImageColor3 = Color3.new(1,1,1),
                        ZIndex = 4,
                        create 'UIGradient' {
                            Color = ColorConfig.LightToDarkBlueGradient,
                            Rotation = 90,
                        }
                    },
                    create 'ImageLabel' {
                        Image = Icons.UpgradeLogo or '',
                        Size = UDim2.fromScale(1, 1.15),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5,0.54),
                        BackgroundTransparency = 1,
                        ScaleType = Enum.ScaleType.Crop,
                        ImageColor3 = Color3.new(0, 0, 0),
                        ImageTransparency = 0.6
                    },
                },
                TextSizeConstraint = {
                    MinTextSize = 40,
                    MaxTextSize = 45,
                },
            }),
            --// Inventory Button
            RoundButton({
                Size = UDim2.fromScale(0.11,1),
                LayoutOrder = 3,
                CircleColor1 = ColorConfig.MainColor,
                StrokeColor2 = ColorConfig.OrangeLight,
                GradientColor1 = ColorConfig.LightToDarkOrangeGradient,
                StrokeColor = Color3.new(),
                Text = 'INVENTORY',
                TextStrokeColor = ColorConfig.OrangeLight,
                TextColor = ColorConfig.MainColor,
                TextGradient = ColorConfig.LightToDarkOrangeGradient,
                OnClick = function() 
                    
                end,
                Children = {
                    create 'ImageLabel' {
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = Icons.CircleTexture,
                        ImageColor3 = ColorConfig.OrangeLight,
                        ImageTransparency = 0.8 ,
                        ZIndex = 0,  
                    },
                    create 'ImageLabel' {
                        Image = Icons.InventoryIcon or '',
                        Size = UDim2.fromScale(1.5, 1.5),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5,0.5),
                        BackgroundTransparency = 1,
                        ScaleType = Enum.ScaleType.Crop,
                        ImageColor3 = Color3.new(1,1,1),
                        create 'UIGradient' {
                            Color = ColorConfig.LightToDarkOrangeGradient,
                            Rotation = 90,
                        },
                        ZIndex = 3
                    },
                    create 'ImageLabel' {
                        Image = Icons.InventoryIcon or '',
                        Size = UDim2.fromScale(1.5, 1.65),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5,0.54),
                        BackgroundTransparency = 1,
                        ScaleType = Enum.ScaleType.Crop,
                        ImageColor3 = Color3.new(0, 0, 0),
                        ImageTransparency = 0.6,
                        ZIndex = 2
                    },
                },
                TextSizeConstraint = {
                    MinTextSize = 30,
                    MaxTextSize = 35,
                },
            })
        }
        
    }


end

return CoreGui