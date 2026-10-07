local ServerScriptService = game:GetService("ServerScriptService")
local DataManager = require(ServerScriptService.Server.Server_Systems.Data.DataManager)

local Default = 1
local LuckService = {}

function LuckService:GetLuck(Player: Player): number
    local PlayerLuck = DataManager:GetLuck(Player)
    if not PlayerLuck then
        return Default
    end
    return PlayerLuck
end

return LuckService