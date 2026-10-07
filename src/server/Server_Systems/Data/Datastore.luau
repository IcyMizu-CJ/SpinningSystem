-- Services
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local runService = game:GetService("RunService")
local DataManager = require(script.Parent.DataManager)
local ServerSignals = require(script.Parent.ServerSignals)
local PS = require(ServerScriptService.ServerPackages.profilestore)

local DATA_TEMPLATE = {
	Creatures = {},
	Index = {},
	Stats = {},
	RollData = {
		Luck = 1,
		RollSpeed = 1,
	},
	Settings = {AutoRoll = false},
	Upgrades = {
		Mutations = 0
	},
	Skins = {
		LuckBuilding = ''
	}

}

-- ProfileStore
local function GetStoreName(): string
	return runService:IsStudio() and "Test1" or "Live"
end

local profileStore = PS.New(GetStoreName(), DATA_TEMPLATE)

local Profiles = DataManager.Profiles

local DS = {}

function DS.Init()
	Players.PlayerAdded:Connect(function(plr: Player)
		local profile = profileStore:StartSessionAsync(`{plr.UserId}`, {
			Cancel = function()
				return plr.Parent ~= Players
			end,
		})

		if profile then
			profile:AddUserId(plr.UserId)
			profile:Reconcile()

			profile.OnSessionEnd:Connect(function()
				Profiles[plr] = nil
				plr:Kick("Please rejoin profile session ended")
			end)

			ServerSignals.DataLoaded:Fire(plr, profile.Data)


			if plr.Parent == Players then
				print("Add Profile", Profiles)
				Profiles[plr] = profile
			else
				profile:EndSession()
			end
		end
	end)

	Players.PlayerRemoving:Connect(function(plr: Player)
		local profile = Profiles[plr]
		if profile then
			print(`Player Data: `, profile.Data)
			profile:EndSession()
		end
	end)
end

return DS
