local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SingleReel = require(ReplicatedStorage.Shared.UI.Components.SingleReel)

local ReelPool = {}
ReelPool.__index = ReelPool


export type ReelPoolData = {
    Container: Instance,
    Reels: {SingleReel.SingleReel},
}
export type ReelPool = typeof(setmetatable({}:: ReelPoolData, ReelPool))

function ReelPool.new(Frame: Instance): ReelPool
    local self = {}
    self.Container = Frame
    self.Reels = {}

    return setmetatable(self, ReelPool)
end

function ReelPool:Get(Index: number)
    local Reel = self.Reels[Index]::SingleReel.SingleReel
    if Reel then
        
        return Reel
    end

    self.Reels[Index] = SingleReel.new(self.Container)

    return self.Reels[Index]
end

function ReelPool:HideAll()
    local ReelAmount = #self.Reels
    local Finished = 0
    for _, Reel: SingleReel.SingleReel in self.Reels do
        task.spawn(function()
            Reel:SetVis(false)
            Finished += 1
        end)
    end
    repeat
        task.wait()
        until Finished >= ReelAmount
end

return ReelPool