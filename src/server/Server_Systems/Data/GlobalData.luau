local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local MostRolls = DataStoreService:GetOrderedDataStore('MostRolls')

local GlobalData = {}

function GlobalData:Init()
    Players.PlayerAdded:Connect(function(plr: Player)  
    
    end)
end

return GlobalData