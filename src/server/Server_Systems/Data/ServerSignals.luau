local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Types = require(ReplicatedStorage.Shared.Types)
return {
    DataLoaded = Signal.new():: Signal.Signal<Player,Types.PlayerData>,
    Patch = Signal.new():: Signal.Signal<Player,string, any>,
}