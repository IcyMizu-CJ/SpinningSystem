local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
return {
    OnClick = Signal.new(),
    AutoRollClick = Signal.new(),
}