local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReelItem = require(script.Parent.ReelItem)
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create 

local SingleReel = {}
SingleReel.__index = SingleReel

export type SingleReelData = {
   Reel: Instance,
   UIScale: UIScale,
   ReelComponents: {ReelItem.ReelItem},
}
export type SingleReel = typeof(setmetatable({}:: SingleReelData, SingleReel))

function SingleReel.new(Container: Instance): SingleReel
    local self = {}
    self.Reel = create 'Frame' {
        Size = UDim2.fromScale(.17, 1),
        BackgroundTransparency = 1,
        create "UIAspectRatioConstraint" {
                AspectRatio = .3
            },

        create "UISizeConstraint" {},
        Visible = false
    }
    self.Reel.Parent = Container

    self.UIScale = create 'UIScale' {
        Scale = 0,
        Parent = self.Reel,
    }

    self.ReelComponents = {}
    for _ = 1,5 do
        if self.Reel == nil then
            continue
        end
        table.insert(self.ReelComponents,ReelItem.new(self.Reel))
    end
    return setmetatable(self, SingleReel)
end

function SingleReel:SetIndex(Index: number)
   self.Reel.LayoutOrder = Index
end

function SingleReel:SetVis(Visible: boolean)
    --// Playing ReelItem animation ( setting scale to 0 )
    if not Visible then
        local Finished = 0
        local ToFinish = #self.ReelComponents
        for _, RI in self.ReelComponents do
            task.spawn(function()
                RI:Hide()
                Finished += 1
            end)
        end
        repeat 
            task.wait()
        until Finished >= ToFinish 
    end
    self.Reel.Visible = Visible
end

function SingleReel:AppearScale()
    for i = 0 , 1 , 0.1 do
        self.UIScale.Scale = i
        task.wait()
    end
end

return SingleReel