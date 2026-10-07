local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)

local RollingState = {}

RollingState.ParentReels = vide.source(nil)
RollingState.ActiveReels = vide.source(0)

RollingState.CleanUp = function()
    RollingState.ActiveReels(0)
end

return RollingState