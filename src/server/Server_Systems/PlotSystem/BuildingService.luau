local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuildingClass = require(script.Parent.BuildingClass)
local BuildingConfig = require(ReplicatedStorage.Shared.Systems.PlotSystem.BuildingConfig)
local Types = require(ReplicatedStorage.Shared.Types)
local BuildingService = {}


function BuildingService:CreateBuildingsForPlayer(PlayerData: Types.PlayerData,Plot: Types.PlotInstance)
    local Buildings = {}
    --// Go trough building config and make a building object for each building in the config
    for _,BuildingBetaData in BuildingConfig:: {Types.BuildingConfig} do
        Buildings[BuildingBetaData.Id] = BuildingClass.new(
            BuildingBetaData.Id,
            PlayerData.Skins[BuildingBetaData.Id], -- Current player skin for said building
            Plot.Buildings[BuildingBetaData.Id].Spawn, -- Where spawn is on plot for the building
            Plot.Buildings[BuildingBetaData.Id].Model
        )
    end

    return Buildings
end

function BuildingService:DestroyAllBuildings(BuildingsTable: {BuildingClass.BuildingClass})
    for _, Building in BuildingsTable do
        Building:Destroy()
    end
end



return BuildingService