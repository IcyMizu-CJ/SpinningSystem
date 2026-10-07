local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Shared.Systems.Configs.GameConfig)
--local RunService = game:GetService("RunService")
local ML = {}

local GameModules = {}
local Modules = {
	[1] = {}, -- FIRST PRIORITY
	[2] = {}, -- SECOND PRIORITY
	[3] = {}, -- THIRD PRIORITY
}

local function InitModules(Folder: Folder)
	local Current_tick = tick()
	for Index, PriorityTable in Modules do
		if GameConfig.Debug then
			warn(`Initializing Priority {Index} Modules`)
		end
		for _, Module in PriorityTable do
			if Module.Init then
				task.defer(function()
					Module:Init(GameModules)
				end)
			end
		end
	end
	if GameConfig.Debug then
		warn(`Modules on {Folder.Name} initialized took {tick() - Current_tick}ms`)
	end
end

function ML.LoadModules(Folder: Folder)
	for _, Module in Folder:GetDescendants() do
		if Module:IsA("ModuleScript") then
			local Priority: number = Module:GetAttribute("Priority") or 3
			GameModules[Module.Name] = require(Module)
			table.insert(Modules[Priority], require(Module))
		end
	end
	InitModules(Folder)
end

return ML
