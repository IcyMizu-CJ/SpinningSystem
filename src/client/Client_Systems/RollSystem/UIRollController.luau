local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local packet = require(ReplicatedStorage.Packages.packet)
local vide = require(ReplicatedStorage.Packages.vide)
local RNG = require(ReplicatedStorage.Shared.Systems.RollSystem.RNG)
local RollSignals = require(ReplicatedStorage.Shared.Systems.RollSystem.RollSignals)
local RollingState = require(ReplicatedStorage.Shared.Systems.RollSystem.RollingState)
local Types = require(ReplicatedStorage.Shared.Types)
local ReelItemModule = require(ReplicatedStorage.Shared.UI.Components.ReelItem)
local SingleReel = require(ReplicatedStorage.Shared.UI.Components.SingleReel)
local ReelPool = require(ReplicatedStorage.Shared.UI.Pools.ReelPool)
local PlayerConfigState = require(ReplicatedStorage.Shared.UI.States.PlayerConfigState)

local RequestRoll = packet("RequestRoll")
local RecieveRoll = packet('SendRoll',packet.Any:: {Types.JobRoll})
local ResolveRoll = packet('ResolveRoll')

-- AutoRoll Packets
local ChangeAutoRollState = packet('ChangeAutoRollState')

local Reels = nil:: ReelPool.ReelPool?
local UIRollController = {}
UIRollController.Active = false

function UIRollController:Init()
    RecieveRoll.OnClientEvent:Connect(function(BatchQueue: {Types.JobRoll})
        UIRollController.Active = true
        UIRollController:Play(BatchQueue)
    end)

    RollSignals.OnClick:Connect(function()
        UIRollController:RollButtonOnClick()
    end)

    RollSignals.AutoRollClick:Connect(function()
        UIRollController:AutoRollOnClick()
    end)

    if not RollingState.ParentReels then
        repeat
            task.wait(1)
            until RollingState.ParentReels

    end
    Reels = ReelPool.new(RollingState.ParentReels())

end

local db = false
function UIRollController:RollButtonOnClick()
    if UIRollController.Active or db or PlayerConfigState.AutoRoll() == true then
        return
    end
    db = true
    RequestRoll:Fire()
    task.delay(1, function()
        db = false
    end)
end

local db2 = false
function UIRollController:AutoRollOnClick()
    if db2 then
        return
    end
    db2 = true
    ChangeAutoRollState:Fire()
    task.delay(1, function()
        db2 = false
    end)
end

local function GetTargetScale(y: number): number
    local center = 0.5

    local distance = math.abs(y - center)

    local minscale = 0
    local maxscale = 1.7

    local alpha = math.clamp(distance/0.5, 0, 1)
    alpha = alpha ^ 0.65

    return maxscale + (minscale - maxscale) * alpha
end

local function CheckSizeThreshhold(ReelItem: ReelItemModule.ReelItem,dt: number)
    local Ypos = ReelItem:GetYPos()
    local TargetScale = GetTargetScale(Ypos)
    local currentscale = ReelItem.UIScale.Scale

    local speed = 12
    local alpha = math.clamp(dt * speed, 0, 1)
    local newscale = currentscale + (TargetScale - currentscale) * alpha
    if newscale <= 0.2 then
        newscale = 0
    end
    ReelItem:SetScale(newscale)
end

function UIRollController:Play(BatchQueue: {Types.JobRoll})
    if not Reels then
        self.Active = false
        ResolveRoll:Fire()
        return
    end 
    
    local JobsToFinish = 0
    local JobsFinished = 0

    for IndxSecond, Jobs in BatchQueue do
        local ExtraIndex = 10 * (IndxSecond-1)
        JobsToFinish += #Jobs.steps
        task.spawn(function()
            for Index,Step in Jobs.steps do
                local Reel = Reels:Get(ExtraIndex+Index)
                Reel:SetVis(true)
                Reel:SetIndex(ExtraIndex+Index)

                local StepAmount = vide.read(RollingState.ActiveReels())
                RollingState.ActiveReels(StepAmount+1)

                for Ind, ReelItem in Reel.ReelComponents do
                    local StartPosY = (0.25 *(Ind-1))
                    ReelItem.StartPosY = StartPosY
                    ReelItem.PrevPosY = StartPosY
                    ReelItem:SetPos(UDim2.fromScale(.5, StartPosY ))
                    local RandomStep = RNG:CreateStep({BonusLuck = PlayerConfigState.BonusLuck(),WildLuck = PlayerConfigState.WildLuck(),PlayerLuck = PlayerConfigState.PlayerLuck()})
                    ReelItem:SetStep(RandomStep)
                end
                
                Reel:AppearScale()
                UIRollController:Animate(Reel,Step)
                JobsFinished+=1
            end
        end)
    end
    repeat
        task.wait()
    until JobsToFinish == JobsFinished
    UIRollController:Finish()
end

function UIRollController:Animate(Reel: SingleReel.SingleReel,WinningStep: Types.JobStep)
    local Windex = 3
    local SpinRounds = 5
    local Increment = 0.25
    local OneRoundSize = #Reel.ReelComponents*Increment
    
    local elapsed = 0
    local completed = false

    local conn = nil
    conn = RunService.Heartbeat:Connect(function(dt: number)
        elapsed += dt
        local progress = elapsed/vide.read(PlayerConfigState.RollSpeed())
        local Alpha = TweenService:GetValue(progress, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
        local ClampAlpha = math.clamp(Alpha, 0, 1)
        
        for Ind, ReelItem in Reel.ReelComponents do
        
            local StartPosY = ReelItem.StartPosY
            local CurrentY = (StartPosY+((OneRoundSize*SpinRounds)*ClampAlpha))
            local WrappedY = CurrentY%OneRoundSize
            local PrevY = ReelItem.PrevPosY
            if WrappedY < PrevY then
                local RandomStep = RNG:CreateStep({BonusLuck = PlayerConfigState.BonusLuck(),WildLuck = PlayerConfigState.WildLuck(),PlayerLuck = PlayerConfigState.PlayerLuck()})
                ReelItem:SetStep(RandomStep)
            end
            --// 5 Is the amount of reelitems 
            if ClampAlpha >= 0.8 and Ind == Windex then
                ReelItem:SetStep(WinningStep)
            end
            ReelItem.PrevPosY = WrappedY
            ReelItem:SetPos(UDim2.fromScale(0.5,CurrentY%OneRoundSize))
            CheckSizeThreshhold(ReelItem,dt)
        end

        if progress >= 1 then
            conn:Disconnect()
            for ind , ReelItem in Reel.ReelComponents do
                if ind == Windex then
                    continue
                end
                task.spawn(ReelItem.Hide,ReelItem)
            end
            Reel.ReelComponents[Windex]:FinishStep(WinningStep)
            completed = true
            return
        end
    end)

    repeat
        task.wait()
        until completed
end

function UIRollController:Finish()
    task.wait(0.8)
    Reels:HideAll()
    self.Active = false
    RollingState.CleanUp()
    ResolveRoll:Fire()
end

return UIRollController