local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local RollSignals = require(ReplicatedStorage.Shared.Systems.RollSystem.RollSignals)
local RollingState = require(ReplicatedStorage.Shared.Systems.RollSystem.RollingState)
local ColorConfig = require(ReplicatedStorage.Shared.UI.ColorConfig)
local RoundButtonWithoutText = require(ReplicatedStorage.Shared.UI.Components.RoundButtonWithoutText)
local Icons = require(ReplicatedStorage.Shared.UI.Icons)
local PlayerConfigState = require(ReplicatedStorage.Shared.UI.States.PlayerConfigState)
local UIState = require(ReplicatedStorage.Shared.UI.States.UIState)
local UseAnimated3Value = require(ReplicatedStorage.Shared.Utility.UseAnimated3Value)
local UseAnimatedValue = require(ReplicatedStorage.Shared.Utility.UseAnimatedValue)

local create = vide.create

local function SpinningGui (props)
    props = props or {}

    local SpinningActive = vide.derive(function()
        return UIState.ActiveScreen() == 'Spinning'
    end)

    local InstanceTransparency = vide.derive(function()  
       if SpinningActive() then
            return 0.3
       else
            return 1
       end 
    end)
    local TextureTransparency = vide.derive(function()  
       if SpinningActive() then
            return 0.8
       else
            return 1
       end
    end)
    local display_overlay = vide.spring(InstanceTransparency,.3)
    local Texture_overlay = vide.spring(TextureTransparency,.3)

    local visible = vide.derive(function()
        return props.Preview or UIState.ActiveScreen() == "Spinning"
    end)

    local Scale = vide.derive(function()
        local ActiveReels = RollingState.ActiveReels()
        local ActivScreen = UIState.ActiveScreen()
        if ActivScreen == 'Spinning' then
            local Increment = 1.075
            return 1 - ((Increment ^ ActiveReels)-1)
        else
            return 1
        end
    end)

    local ArrowScale = vide.derive(function()
        local ActiveReels = RollingState.ActiveReels()

        if ActiveReels >= 1 then
            return 2
        else
            return 0
        end
    end)

    local UILayPadding = vide.derive(function()
        if SpinningActive() then
            return UDim.new(0.13,0)
        else
            return UDim.new(0.06,0)
        end
    end)

    local AutoRoll = vide.derive(function()
        local AutoRollState = PlayerConfigState.AutoRoll()

        if AutoRollState then
	        return [[<b>AutoRoll</b> <font color="rgb(0,255,0)">On</font>]]
        else
	        return [[<b>AutoRoll</b> <font color="rgb(255,0,0)">Off</font>]]
        end
    end)

    local Clipping = vide.derive(function()
        local Visible = visible()
        return not Visible
    end)

    local ReelsPosAdjusted = vide.derive(function()
        --// Adjust the reels frame depending on state, if its active not active or semi active(not tabbed into spinning screen)
        if UIState.ActiveScreen() == "Spinning" then
            return 'on'
        elseif UIState.ActiveScreen() == 'CoreGui' then
            return 'mid'
        end
        return 'off'
    end)

    local ReelsPos = UseAnimated3Value({when = ReelsPosAdjusted,on = UDim2.fromScale(.5, .5),off = UDim2.fromScale(.5, -1),mid = UDim2.fromScale(.5, 0) })
    local ReelsAnchor = UseAnimatedValue({when = visible,on = Vector2.new(.5, .5),off = Vector2.new(.5, 0) })
    local ReelsSize = UseAnimatedValue({when = visible,on = UDim2.fromScale(1, 1),off = UDim2.fromScale(1, 0.3) })
    local BottomPos = UseAnimatedValue({when = visible,on = UDim2.fromScale(.5, .92),off = UDim2.fromScale(.5, 1.92) })

    return 
        create 'Frame' {
            Name = 'Overlay',
            Size = UDim2.fromScale(1, 1),
            AnchorPoint = Vector2.new(.5,.5),
            Position = UDim2.fromScale(.5, .5),
            BackgroundTransparency = display_overlay,
            BackgroundColor3 = ColorConfig.MainColor,

            create 'ImageLabel' {
                Size = UDim2.fromScale(1, 1),
                AnchorPoint = Vector2.new(.5,.5),
                Position = UDim2.fromScale(.5, .5),
                BackgroundTransparency = 1,
                ImageTransparency = Texture_overlay,
                Image = Icons.LongSquareText,
                ScaleType = Enum.ScaleType.Crop,
                ImageColor3 = ColorConfig.MainColor
            },

            create 'Frame' {
                Name = 'Reels',
                Size = ReelsSize,
                AnchorPoint = ReelsAnchor,
                Position = ReelsPos,
                BackgroundTransparency = 1,                
                ZIndex = 2,
                Visible = true,
                ClipsDescendants = Clipping,
                create 'UIListLayout' {
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UILayPadding
                },

                create 'UIScale' {
                    Scale = vide.spring(Scale)
                },

                -- CREATE SINGLE REEL
               
               vide.action(function(Frame: Instance)
                    RollingState.ParentReels(Frame)
               end),

               create 'ImageLabel' {
                    Size = UDim2.fromScale(0.2, 0.2),
                    AnchorPoint = Vector2.new(.5,.5),
                    Position = UDim2.fromScale(.5, .5),
                    BackgroundTransparency = 1,
                    Image = Icons.Arrow,
                    Name = 'Left Arrow',
                   -- ImageColor3 = ColorConfig.MainAccentColor,
                    create "UIAspectRatioConstraint" {
                        AspectRatio = 1
                    },

                    create "UISizeConstraint" {
                        MinSize = Vector2.new(70, 70),
                        MaxSize = Vector2.new(180, 180),
                    },
                    LayoutOrder = 0,
                    ScaleType = Enum.ScaleType.Fit,
                    create 'UIScale' {
                        Scale = vide.spring(ArrowScale,.3)
                    },
               },

               create 'ImageLabel' {
                    Size = UDim2.fromScale(0.2, 0.2),
                    AnchorPoint = Vector2.new(.5,.5),
                    Position = UDim2.fromScale(.5, .5),
                    BackgroundTransparency = 1,
                    Image = Icons.Arrow2,
                    Name = 'Right Arrow',
                   -- ImageColor3 = ColorConfig.MainAccentColor,
                    create "UIAspectRatioConstraint" {
                        AspectRatio = 1
                    },

                    create "UISizeConstraint" {
                        MinSize = Vector2.new(70, 70),
                        MaxSize = Vector2.new(180, 180),
                    },
                    Rotation = 180,
                    LayoutOrder = 99999999,
                    ScaleType = Enum.ScaleType.Fit,
                    create 'UIScale' {
                        Scale = vide.spring(ArrowScale,.3)
                    },
               }

            },

            create 'Frame' {
                Name = 'BottomUi',
                Size = UDim2.fromScale(1, 0.2),
                AnchorPoint = Vector2.new(.5,1),
                Position = BottomPos,
                BackgroundTransparency = 1, 
                ZIndex = 2,              
                
                create 'UIListLayout' {
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(.65)
                },

                RoundButtonWithoutText{
                    Size = UDim2.fromScale(.09, .7),
                    Icon = Icons.BackArrow,
                    LayoutOrder = 2,
                    GradientStroke = ColorConfig.LightToDarkPurpleGradient,
                    CircleColor = ColorConfig.MainColor,
                    BackgroundTransparency = 0.2,
                    OnClick = function()
                        UIState.ActiveScreen('CoreGui')
                    end,
                     Children = {
                        create 'TextLabel' {
                            Size = UDim2.fromScale(1, 0.5),
                            AnchorPoint = Vector2.new(0.5,0.5),
                            Position = UDim2.fromScale(0.5, 1.3),
                            Text = 'Go Back',
                            FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
                            RichText = true,
                            TextScaled = true,
                            BackgroundTransparency = 1,
                            TextWrapped = true,
                            TextColor3 = Color3.new(1, 1, 1),
                            ZIndex = 5,
                        }
                    }
                },

                 RoundButtonWithoutText{
                    Size = UDim2.fromScale(.09, .7),
                    LayoutOrder = 1,
                    GradientStroke = ColorConfig.LightToDarkPurpleGradient,
                    CircleColor = ColorConfig.MainColor,
                    Icon = Icons.AutoRoll,
                    BackgroundTransparency = 0.2,
                    OnClick = function()
                        RollSignals.AutoRollClick:Fire()
                    end,
                    Children = {
                        create 'TextLabel' {
                            Size = UDim2.fromScale(1, 0.5),
                            AnchorPoint = Vector2.new(0.5,0.5),
                            Position = UDim2.fromScale(0.5, 1.3),
                            Text = AutoRoll,
                            FontFace = Font.fromName('Teko',Enum.FontWeight.Regular),
                            RichText = true,
                            TextScaled = true,
                            BackgroundTransparency = 1,
                            TextWrapped = true,
                            TextColor3 = Color3.new(1, 1, 1),
                            ZIndex = 5,
                        },
                        create 'TextLabel' {
                            Size = UDim2.fromScale(1, 0.5),
                            AnchorPoint = Vector2.new(0.5,0.5),
                            Position = UDim2.fromScale(0.5, 1.32),
                            Text = AutoRoll,
                            FontFace = Font.fromName('Teko',Enum.FontWeight.Regular),
                            TextScaled = true,
                            BackgroundTransparency = 1,
                            TextWrapped = true,
                            TextColor3 = Color3.new(1, 1, 1),
                            ZIndex = 4,
                            create 'UIGradient' {
                                Color = ColorConfig.LightToDarkPurpleGradient
                            }
                        },
                    }
                },

            },

        }

end

return SpinningGui