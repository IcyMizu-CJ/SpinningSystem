local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local Types = require(ReplicatedStorage.Shared.Types)
local create = vide.create

local BonusItemFrame = {}
BonusItemFrame.__index = BonusItemFrame

type self = {
    Bonus: TextLabel
}

export type BonusItemFrame = typeof(setmetatable({}:: self, BonusItemFrame))

function BonusItemFrame.new(Parent: Instance)
    local self = {}

    self.Bonus = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1.35, 1),
        Position = UDim2.fromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = Parent,
        Text = 'BONUS',
        TextColor3 = Color3.new(),
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        RichText = true,
        TextScaled = true,
        TextWrapped = true,
        Visible = false,
        create 'TextLabel' {
            AnchorPoint = Vector2.new(.5,.5),
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(.5,.46),
            BackgroundTransparency = 1,
            Text = 'BONUS',
            TextScaled = true,
            RichText = true,
            FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
            TextColor3 = Color3.new(1,1,1),
            ZIndex = 0,
            create 'UIGradient' {
            Color = ColorSequence.new(
               {ColorSequenceKeypoint.new(0.00, Color3.new(0.02, 0.82, 1.00)), 
                ColorSequenceKeypoint.new(0.50, Color3.new(0.02, 0.82, 1.00)), 
                ColorSequenceKeypoint.new(0.61, Color3.new(0.00, 0.29, 0.53)), 
                ColorSequenceKeypoint.new(1.00, Color3.new(0.00, 0.29, 0.53))}
            ),
            Rotation = 90,
        },
        }

    }

    return setmetatable(self, BonusItemFrame)
end

function BonusItemFrame:Clear()
    self.Bonus.Visible = false
end

function BonusItemFrame:Create(_Step: Types.JobStep)
     self.Bonus.Visible = true
end

return BonusItemFrame