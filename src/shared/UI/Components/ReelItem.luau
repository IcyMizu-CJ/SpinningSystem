local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CreatureItemFrame = require(script.Parent.ItemFrameComponents.CreatureItemFrame)
local vide = require(ReplicatedStorage.Packages.vide)
local Types = require(ReplicatedStorage.Shared.Types)
local BonusItemFrame = require(ReplicatedStorage.Shared.UI.Components.ItemFrameComponents.BonusItemFrame)
local WildItemFrame = require(ReplicatedStorage.Shared.UI.Components.ItemFrameComponents.WildItemFrame)
local create = vide.create

local ReelItem = {}
ReelItem.__index = ReelItem

export type ReelItemData = {
    Image: ImageLabel,
    Bonus: TextLabel,
    Frame: Instance,
    ItemFrames: {
        CreatureItemFrame: CreatureItemFrame.CreatureItemFrame,
    },
    UIScale: UIScale,
    PrevPosY: number,
    StartPosY: number,
}
export type ReelItem = typeof(setmetatable({}:: ReelItemData, ReelItem))

function ReelItem.new(Container: Instance)
    local self = {}
    self.Frame = create 'Frame' {
        BackgroundColor3 = Color3.new(),
        Size = UDim2.fromScale(1, 0.24),
        AnchorPoint = Vector2.new(.5,.5),
        BackgroundTransparency = 1,

        create "UIAspectRatioConstraint" {
            AspectRatio = 1
        },

        create "UISizeConstraint" {},
    }
    self.Frame.Parent = Container

    self.Image = create 'ImageLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Visible = false
    }

    self.ItemFrames = {}
    self.ItemFrames.Creature = CreatureItemFrame.new(self.Frame)
    self.ItemFrames.Wild = WildItemFrame.new(self.Frame)
    self.ItemFrames.Bonus = BonusItemFrame.new(self.Frame)

    self.UIScale = create 'UIScale' {
        Scale = 1,
        Parent = self.Frame,
    }

    self.PrevPosY = 0
    self.StartPosY = 0

    return setmetatable(self, ReelItem)
end

function ReelItem:Clear()
    for _,ItemFrames in self.ItemFrames do
        if ItemFrames.Clear then
            ItemFrames:Clear()
        end
    end

    self.Image.Visible = false
end

function ReelItem:SetStep(Step: Types.JobStep)
    self:Clear()

    if self.ItemFrames[Step.type] and self.ItemFrames[Step.type].Create then
        self.ItemFrames[Step.type]:Create(Step)
        return
    end
end

function ReelItem:FinishStep(Step: Types.JobStep)
    if self.ItemFrames[Step.type] and self.ItemFrames[Step.type].Finish then
        self.ItemFrames[Step.type]:Finish(Step)
    end
end

function ReelItem:SetPos(Pos: UDim2)
    self.Frame.Position = Pos
end

function ReelItem:SetScale(Scale: number)
    self.UIScale.Scale = Scale
end

function ReelItem:GetYPos()
    return self.Frame.Position.Y.Scale
end

function ReelItem:Hide()
    local tween = TweenService:Create(self.UIScale, TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0.2), {Scale = 0})
    tween:Play()
    tween.Completed:Wait()
end

return ReelItem