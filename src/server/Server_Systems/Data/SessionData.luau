local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RollConfig = require(ReplicatedStorage.Shared.Systems.RollSystem.RollConfig)
local Types = require(ReplicatedStorage.Shared.Types)
local DeepCopyTable = require(ReplicatedStorage.Shared.Utility.DeepCopyTable)
local SessionService = {}
local SessionDataTemplate = {
    RollData = {
        Active = false,
        RollCount = 1,
        Queue = {}
    }
}

local SessionData = {}


function SessionService:Init()
    Players.PlayerAdded:Connect(function(Player: Player)
        SessionData[Player] = DeepCopyTable:Copy(SessionDataTemplate)
    end)

    Players.PlayerRemoving:Connect(function(Player: Player)
        SessionData[Player] = nil
    end)
end

function SessionService:AddToJobQueue(Player: Player,Job: Types.JobRoll)
    local profile = SessionData[Player]
    if not profile then
        return
    end
    table.insert(profile.RollData.Queue,Job)
end

function SessionService:ClearJobQueue(Player: Player)
    local profile = SessionData[Player]
    if not profile then
        return
    end
    table.clear(profile.RollData.Queue)
end

--//Setters

function SessionService:SetRollActive(Player: Player,Bool: boolean)
    local profile = SessionData[Player]
    if not profile then
        return
    end
    profile.RollData.Active = Bool
end

--//Getters

function SessionService:GetSessionData(Player: Player): Types.SessionData|nil
    local profile = SessionData[Player]
    if not profile then
        return nil
    end
    return profile
end

function SessionService:GetRollCount(Player)
    local profile = SessionData[Player]
    if not profile then
        return nil
    end
    return profile.RollData.RollCount
end

function SessionService:GetBonusLuck(_Player: Player): number
    return RollConfig.BaseBonusOdds
end

function SessionService:GetWildLuck(_Player: Player): number
    return RollConfig.BaseWildsOdds
end

return SessionService