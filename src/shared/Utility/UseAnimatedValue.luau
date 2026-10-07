local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UtilityTypes = require(script.Parent.UtilityTypes)
local vide = require(ReplicatedStorage.Packages.vide)


local function UseAnimatedValue<T> (Config: UtilityTypes.UseAnimatedValue<T>)
    local target = vide.derive(function()  
        return Config.when() and Config.on or Config.off
    end)

    return vide.spring(target,Config.speed or 1,Config.damping or nil)
end


return UseAnimatedValue