local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local RollConfig = require(ReplicatedStorage.Shared.Systems.RollSystem.RollConfig)

local PCS = {}

PCS.RollSpeed = vide.source(1)
PCS.AutoRoll = vide.source(false)
PCS.PlayerLuck = vide.source(1)
PCS.BonusLuck = vide.source(RollConfig.BaseBonusOdds)
PCS.WildLuck = vide.source(RollConfig.BaseWildsOdds)

return PCS