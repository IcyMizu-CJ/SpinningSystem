local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage.Shared.Systems.ModuleLoader)
ModuleLoader.LoadModules(script.Parent.Client_Systems)
