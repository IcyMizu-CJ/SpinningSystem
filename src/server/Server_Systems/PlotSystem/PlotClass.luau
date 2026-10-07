local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuildingClass = require(script.Parent.BuildingClass)
local BuildingService = require(script.Parent.BuildingService)
local Types = require(ReplicatedStorage.Shared.Types)

local PlotClass = {}
PlotClass.__index = PlotClass

type selfData = {
    PlotInstance: Types.PlotInstance,
    Player: Player,
    Buildings: {[string]: BuildingClass.BuildingClass}
}

export type PlotClass = typeof(setmetatable({}:: selfData, PlotClass))


function PlotClass.new(Player: Player, PlayerData: Types.PlayerData,Plot: Types.PlotInstance)
    local self = {}
    self.PlotInstance = Plot
    self.Player = Player

    --//Creating Buildings
    self.Buildings = BuildingService:CreateBuildingsForPlayer(PlayerData,Plot)

    return setmetatable(self, PlotClass)
end

function PlotClass:Load()
    self.PlotInstance.PlotIndicator:WaitForChild("BillboardGui"):WaitForChild('Frame'):WaitForChild('Text1')
    self.PlotInstance.PlotIndicator:WaitForChild("BillboardGui"):WaitForChild('Frame'):WaitForChild('Text2')
    --//  Setting plot indicator
    self:SetIndicator(self.Player.Name,true)

    --// Set Player Spawn Location to plot spawn location, and also teleport them there
    self:SetupSpawn(true)
    --// Reloading Character
    self.Player:LoadCharacterAsync()

    for _, Building in self.Buildings do
        --// Making sure to clear the folder where model will load into
        --self.PlotInstance.Buildings[Building.Id].Model:ClearAllChildren()
        --// Loading the building / spawning building in
        Building:Load()
    end
end

function PlotClass:Clean()
    --// Setting indicator to nil
    self:SetIndicator('Player_None',false)
    --// Setting spawnlocation as non active
    self:SetupSpawn(false)
    --// Destroying all buildings and clearing memory
    BuildingService:DestroyAllBuildings(self.Buildings)
end

function PlotClass:SetupSpawn(Active: boolean)
    --// Setting players spawn to a spawnlocation and enabling the spawnlocation
    local SpawnLocation = self.PlotInstance:FindFirstChild("SpawnLocation")
    SpawnLocation.Enabled = Active
    self.Player.RespawnLocation = SpawnLocation
end

function PlotClass:SetIndicator(TextToReplace: string,_SetEnabled: boolean)
    self.PlotInstance.PlotIndicator.BillboardGui.Frame.Text1.Text = TextToReplace
    self.PlotInstance.PlotIndicator.BillboardGui.Frame.Text2.Text = TextToReplace
end

function PlotClass:Reskin()

end

return PlotClass