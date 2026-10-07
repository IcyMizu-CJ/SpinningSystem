local HttpService = game:GetService("HttpService")
local id = {}

function id:Create(Name: string)
    return HttpService:GenerateGUID()..Name
end

return id