local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)
local Types = require(ReplicatedStorage.Shared.Types)
local PlayerConfigState = require(ReplicatedStorage.Shared.UI.States.PlayerConfigState)

local RecieveSnapShot = packet('SendDataSyncSnapshot', packet.Any:: Types.SnapshotSyncData)
local SendPatch = packet('SendDataSyncPatch', packet.String, packet.Any)

local PDC = {}

function PDC:Init()

    RecieveSnapShot.OnClientEvent:Connect(function(SnapshotSyncData: Types.SnapshotSyncData)
        for dataName,dataValue in SnapshotSyncData do
            if PlayerConfigState[dataName] then
                PlayerConfigState[dataName](dataValue)
            end
        end
    end)

    SendPatch.OnClientEvent:Connect(function(Key: string, Data: any)
        if PlayerConfigState[Key] then
            PlayerConfigState[Key](Data)
        end
    end)

end

return PDC