local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TeleportService = game:GetService("TeleportService")
local PlotClass = require(script.Parent.PlotClass)
local GameConfig = require(ReplicatedStorage.Shared.Systems.Configs.GameConfig)
local Types = require(ReplicatedStorage.Shared.Types)
local ServerSignals = require(ServerScriptService.Server.Server_Systems.Data.ServerSignals)

local PlotService = {}
local PlotProfiles = {}
local PlotAvailable = {}

function PlotService:Init()

    -- On PlayerJoin
    ServerSignals.DataLoaded:Connect(function(Player: Player, PlayerData: Types.PlayerData)
        local Plots = CollectionService:GetTagged('Plot')
        for _ , PlotInstance in Plots do
            --Check if plot available
            if table.find(PlotAvailable, PlotInstance) then
                -- Plot is not available
                continue
            end

            --Checking to make sure player doesnt already have a plot
            if PlotProfiles[Player] then
                --If player does have a plot already then make player rejoin
                TeleportService:Teleport(GameConfig.PlaceId,Player)
                break
            end

            --If player does not own a plot and there is a plot available then grant them one
            self:AddPlot(Player,PlayerData,PlotInstance)
            
        end
        
        --// If player still does not have a plot kick them/rejoin them
        if PlotProfiles[Player] == nil then
            TeleportService:Teleport(GameConfig.PlaceId,Player)
        end

    end)

    Players.PlayerRemoving:Connect(function(Player: Player)
        self:CleanupPlot(Player)
    end)

end

function PlotService:AddPlot(Player: Player, PlayerData: Types.PlayerData,Plot: Types.PlotInstance)
    --// Add plot to plotavailable table to indicate its taken
    table.insert(PlotAvailable,Plot)
    --// Add the plotclass to the plotprofiles to a player
    PlotProfiles[Player] = PlotClass.new(Player, PlayerData, Plot)
    PlotProfiles[Player]:Load()
end

function PlotService:RemovePlot(Player: Player,Plot: Types.PlotInstance)
    --// Remove the plotclass from the player to free up memory
    PlotProfiles[Player] = nil
    --// Remove plot from plotavailable so it can be available again
    local Index = table.find(PlotAvailable,Plot)
    table.remove(PlotAvailable,Index)
end

function PlotService:CleanupPlot(Player: Player)
    local Plot = PlotProfiles[Player]:: PlotClass.PlotClass
    if not Plot then
        warn(`{Player} has no plot`)
        return
    end

    Plot:Clean()

    PlotService:RemovePlot(Player, Plot.PlotInstance)
end

return PlotService