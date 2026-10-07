local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BuildingConfig = require(ReplicatedStorage.Shared.Systems.PlotSystem.BuildingConfig)
local Types = require(ReplicatedStorage.Shared.Types)

local IgnoreBuildingAnimTag = 'IgnoreBuildingAnim' --// If this tag is on a part in a building model it wont be animated


--Loading Animation TweenInfo
local BuildingTween = TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)

local BuildingClass = {}
BuildingClass.__index = BuildingClass

type selfData = {
    CurrentModel: Model?,
    CurrentSkin: string,
    SpawnPoint: Instance,
    Id: string,
    Config: Types.BuildingConfig,
    ParentFolder: Folder,
}

export type BuildingClass = typeof(setmetatable({}:: selfData, BuildingClass))

function BuildingClass.new(Id: string,CurrentSkin: string,SpawnPoint: Instance,ParentFolder: Folder): BuildingClass
    local self = {
    Id = Id,
    CurrentModel = nil,
    CurrentSkin = CurrentSkin,
    SpawnPoint = SpawnPoint,
    Config = BuildingConfig[Id],
    ParentFolder = ParentFolder,
    }


    return setmetatable(self, BuildingClass)
end

function BuildingClass:Load()
    local Model = ReplicatedStorage.Assets.Buildings[self.Id][self.CurrentSkin or self.Config.DefaultSkin]:Clone():: Model
    if not Model then
        warn(`Issue with Finding Model for building: id:{self.Id} or defaultskin:{self.Config.DefaultSkin}`)
    end

    self.CurrentModel = Model

    Model.Parent = self.ParentFolder
    Model:PivotTo(self.SpawnPoint.CFrame)

    local function LoadAnimation()
        local Offsett = 2
        -- Making Every Part Transparent to get it animate ready
        for Ind, Parts in self.CurrentModel:GetDescendants() do
            Offsett = Ind * 0.25
            if not Parts:IsA('BasePart') and not Parts:IsA("UnionOperation") and not Parts:IsA("Part") and not Parts:IsA("WedgePart") or Parts:HasTag(IgnoreBuildingAnimTag) then
                continue
            end
            Parts.Transparency = 0.8
            Parts.Position = Parts.Position + Vector3.new(Offsett,Offsett,Offsett)
        end
        --Starting Animation
        for Ind, Parts: Part in self.CurrentModel:GetDescendants() do
            Offsett = Ind * 0.25
            if not Parts:IsA('BasePart') and not Parts:IsA("UnionOperation") and not Parts:IsA("Part") and not Parts:IsA("WedgePart") or Parts:HasTag(IgnoreBuildingAnimTag) then
                continue
            end
            local Tween = TweenService:Create(Parts, BuildingTween, {Transparency = 0,Position = Parts.Position - Vector3.new(Offsett,Offsett,Offsett)})
            Tween:Play()
            Tween = nil
        end
    end

    task.spawn(LoadAnimation)

end

function BuildingClass:Destroy()
    self.CurrentModel:Destroy()
    self.CurrentModel = nil
end


return BuildingClass