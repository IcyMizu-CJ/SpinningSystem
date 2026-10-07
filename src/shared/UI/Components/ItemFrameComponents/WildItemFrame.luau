local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local vide = require(ReplicatedStorage.Packages.vide)
local Types = require(ReplicatedStorage.Shared.Types)
local ColorConfig = require(ReplicatedStorage.Shared.UI.ColorConfig)
local Icons = require(ReplicatedStorage.Shared.UI.Icons)
local create = vide.create

local WildItemFrame = {}
WildItemFrame.__index = WildItemFrame

type self = {
    Wild: Frame,
    WildTextBack: TextLabel,
    WildText: TextLabel,
    Scale: UIScale,
    Scale2: UIScale,
}

export type WildItemFrame = typeof(setmetatable({}:: self, WildItemFrame))

function WildItemFrame.new(Parent: Instance)
    local self = {}

    self.Wild = create 'Frame' {
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = ColorConfig.MainColor,
        create 'UIShadow' {
            Color = ColorConfig.MainAccentColor,
            BlurRadius = UDim.new(0.2,0)

        },
        create 'UICorner' {
            CornerRadius = UDim.new(1)
        },
        ClipsDescendants = true,
        Visible = false,
        Parent = Parent,
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
            AnchorPoint = Vector2.new(0.5,0.5),
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = Icons.Wild,
            ImageColor3 = ColorConfig.MainAccentColor,
            ImageTransparency = 0,  
            ZIndex = 1,
        }
    }

    self.WildTextBack = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(0.7, 0.7),
        Position = UDim2.fromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = self.Wild,
        Text = `??X`,
        TextColor3 = Color3.new(),
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        TextScaled = true,
        RichText = true,
        TextWrapped = true,
        ZIndex = 3,
    }
    
    self.WildText = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(0.7,0.7),
        Position = UDim2.fromScale(.54,.46),
        BackgroundTransparency = 1,
        Text = '??X',
        TextScaled = true,
        RichText = true,
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        TextColor3 = Color3.new(1,1,1),
        ZIndex = 4,
        Parent = self.Wild,
        create 'UIGradient' {
            Color = ColorSequence.new(
            {
                ColorSequenceKeypoint.new(0.00, Color3.new(1.00, 0.84, 0.04)),
                ColorSequenceKeypoint.new(0.37, Color3.new(1.00, 0.84, 0.04)),
                ColorSequenceKeypoint.new(0.39, Color3.new(1.00, 1.00, 1.00)),
                ColorSequenceKeypoint.new(0.48, Color3.new(0.92, 0.79, 0.03)),
                ColorSequenceKeypoint.new(0.64, Color3.new(1.00, 1.00, 1.00)),
                ColorSequenceKeypoint.new(0.70, Color3.new(1.00, 0.84, 0.04)),
                ColorSequenceKeypoint.new(1.00, Color3.new(1.00, 0.84, 0.04))
            }
            ),
            Rotation = 90,
        },
        
    }

    self.Scale = create 'UIScale' {
        Scale = 1,
        Parent = self.WildText
    }

    self.Scale2 = create 'UIScale' {
        Scale = 1,
        Parent = self.WildTextBack
    }

    return setmetatable(self, WildItemFrame)
end

function WildItemFrame:Clear()
    self.Wild.Visible = false
    self.WildText.Text = "??X"
    self.WildTextBack.Text = "??X"
end

function WildItemFrame:Create(_Step: Types.JobStep)
     self.Wild.Visible = true
end

function WildItemFrame:Finish(Step: Types.JobStep)
    if Step.type ~= 'Wild' or Step.wildMulti == nil then
        return
    end
     local ran = math.random(2,5)
    local tween = TweenService:Create(
        self.Scale, 
        TweenInfo.new(0.2,Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut,ran,true,0), 
        {Scale = 1.2}
    )
    TweenService:Create(
        self.Scale2, 
        TweenInfo.new(0.2,Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut,ran,true,0), 
        {Scale = 1.2}
    ):Play()
    tween:Play()
    tween.Completed:Wait()

    self.WildText.Text = `{Step.wildMulti}X`
    self.WildTextBack.Text = `{Step.wildMulti}X`
    task.wait(0.2)
end

return WildItemFrame