local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerSignals = require(ServerScriptService.Server.Server_Systems.Data.ServerSignals)
local packet = require(ReplicatedStorage.Packages.packet)
local LuckService = require(ServerScriptService.Server.Server_Systems.Luck.LuckService)
local Types = require(ReplicatedStorage.Shared.Types)


local SendSnapShot = packet('SendDataSyncSnapshot', packet.Any:: Types.SnapshotSyncData)
local SendPatch = packet('SendDataSyncPatch', packet.String, packet.Any)

local PDS = {}

function PDS:Init()

    ServerSignals.DataLoaded:Connect(function(Player: Player, PlrData: Types.PlayerData)
        local SnapShot = PDS.CreateSnapShot(Player,PlrData)
        SendSnapShot:FireClient(Player, SnapShot)
    end)

    ServerSignals.Patch:Connect(function(Player: Player, Key: string, Data: any)
        SendPatch:FireClient(Player, Key, Data)
    end)

end

function PDS.CreateSnapShot(Player: Player,PlrData: Types.PlayerData)
    return {
        RollSpeed = PlrData.RollData.RollSpeed,
        AutoRoll = PlrData.Settings.AutoRoll,
        PlayerLuck = LuckService:GetLuck(Player)
    }
end

return PDS