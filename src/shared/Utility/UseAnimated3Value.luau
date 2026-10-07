local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UtilityTypes = require(script.Parent.UtilityTypes)
local vide = require(ReplicatedStorage.Packages.vide)


local function UseAnimatedValue<T> (Config: UtilityTypes.UseAnimated3Value<T>)
    local target = vide.derive(function()  
        local State = Config.when()
        if Config[State] then
            return Config[State]
        end
    end)

    return vide.spring(target,Config.speed or 1,Config.damping or nil)
end


return UseAnimatedValue