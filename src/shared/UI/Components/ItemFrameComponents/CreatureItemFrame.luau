local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local vide = require(ReplicatedStorage.Packages.vide)
local CreatureConfig = require(ReplicatedStorage.Shared.Systems.Configs.CreatureConfig)
local RarityConfig = require(ReplicatedStorage.Shared.Systems.Configs.RarityConfig)
local Types = require(ReplicatedStorage.Shared.Types)
local Icons = require(ReplicatedStorage.Shared.UI.Icons)
local CreateModelInVieuwport = require(ReplicatedStorage.Shared.Utility.CreateModelInVieuwport)
local create = vide.create

local CreatureItemFrame = {}
CreatureItemFrame.__index = CreatureItemFrame

type self = {
    Shine: ImageLabel,
    OddsTextBack: TextLabel,
    OddsText: TextLabel,
    OddsGradient: UIGradient,
    NameTextBack: TextLabel,
    NameText: TextLabel,
    NameGradient: TextLabel,
    Vieuwport: ViewportFrame,
    Frame: Frame,
    Scale: UIScale,
}

export type CreatureItemFrame = typeof(setmetatable({}:: self, CreatureItemFrame))

function CreatureItemFrame.new(Parent: Instance)
    local self = {}

    self.Frame = create 'Frame' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = Parent,
    }

    self.Scale = create 'UIScale' {
        Scale = 1,
        Parent = self.Frame
    }

    self.Shine = create 'ImageLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Image = Icons.Shine,
        Visible = false,
        ZIndex = 1,
    }

    self.OddsTextBack = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(0.4, 0.4),
        Position = UDim2.fromScale(0.1,0.17),
        Rotation = -22,
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Text = `??/??`,
        TextColor3 = Color3.new(),
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        TextScaled = true,
        TextWrapped = true,
        Visible = false,
        ZIndex = 2,
    }

    self.OddsText = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(0.4, 0.4),
        Position = UDim2.fromScale(0.08,0.15),
        Rotation = -22,
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Text = `??/??`,
        TextColor3 = Color3.new(1, 1, 1),
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        TextScaled = true,
        TextWrapped = true,
        Visible = false,
        ZIndex = 3,
    }
    
    self.OddsGradient = create 'UIGradient' {
        Rotation = 90,
        Parent = self.OddsText
    }

    self.NameTextBack = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1, 0.6),
        Position = UDim2.fromScale(0.5,0.8),
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Text = `?????`,
        TextColor3 = Color3.new(0, 0, 0),
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        TextScaled = true,
        Visible = false,
        ZIndex = 2,
    }

    self.NameText = create 'TextLabel' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1, 0.6),
        Position = UDim2.fromScale(0.48,0.78),
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Text = `?????`,
        TextColor3 = Color3.new(1, 1, 1),
        FontFace = Font.fromName('Teko',Enum.FontWeight.Bold),
        TextScaled = true,
        Visible = false,
        ZIndex = 3,
    }
    
    self.NameGradient = create 'UIGradient' {
        Rotation = 90,
        Parent = self.NameText
    }

    self.Vieuwport = create 'ViewportFrame' {
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = self.Frame,
        Visible = false,
    }

    return setmetatable(self, CreatureItemFrame)
end

function CreatureItemFrame:Clear()
    self.Vieuwport:ClearAllChildren()
    self.Vieuwport.Visible = false
    self.Shine.Visible = false
    self.OddsText.Visible = false
    self.OddsTextBack.Visible = false
    self.NameText.Visible = false
    self.NameTextBack.Visible = false
    self.Scale.Scale = 1
end

function CreatureItemFrame:Create(Step: Types.JobStep)
    if Step.type ~= 'Creature' and Step.creatureId == nil then
        return
    end
    local CreatureInfo = CreatureConfig.Contents[Step.creatureId]:: Types.CreatureConfig or CreatureConfig.Default:: Types.CreatureConfig
    local RarityInfo = RarityConfig.Contents[CreatureInfo.rarity]:: Types.RarityConfig or RarityConfig.Default:: Types.RarityConfig
    self.Shine.Visible = true
    self.Shine.ImageColor3 = RarityInfo.color

    self.OddsText.Text = `1/{CreatureInfo.odds}`
    self.OddsTextBack.Text = `1/{CreatureInfo.odds}`
    self.NameText.Text = CreatureInfo.id
    self.NameTextBack.Text = CreatureInfo.id
    self.OddsGradient.Color = RarityInfo.gradient
    self.NameGradient.Color = RarityInfo.gradient

    self.OddsText.Visible = true
    self.OddsTextBack.Visible = true
    self.NameText.Visible = true
    self.NameTextBack.Visible = true
    CreateModelInVieuwport(self.Vieuwport,Step.creatureId)
    self.Vieuwport.Visible = true
end

function CreatureItemFrame:Finish(Step: Types.JobStep)
     if Step.type ~= 'Creature' and Step.creatureId == nil then
        return
    end
    TweenService:Create(self.Scale, TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0.2), {Scale = 1.35}):Play()
end

return CreatureItemFrame