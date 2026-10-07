local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerSignals = require(script.Parent.ServerSignals)
local Types = require(ReplicatedStorage.Shared.Types)
local DataManager = {}
DataManager.Profiles = {}

local function WaitForProfile(Player: Player): Types.PlayerData?
	local Profile = DataManager.Profiles[Player]
	if not Profile then
		return nil
	end
	return Profile.Data
end 

function DataManager:GetLuck(Player: Player): number | nil
	local Profile = WaitForProfile(Player)
	if not Profile then
		return
	end
	return Profile.Luck
end

function DataManager:GetAutoRoll(Player: Player): boolean | nil
	local Profile = WaitForProfile(Player)
	if not Profile then
		return nil
	end
	return Profile.Settings.AutoRoll
end

function DataManager:SetAutoRoll(Player: Player, boolean: boolean): boolean
	local Profile = WaitForProfile(Player)
	if not Profile then
		return false
	end
	Profile.Settings.AutoRoll = boolean
	ServerSignals.Patch:Fire(Player, 'AutoRoll', boolean)

	return true
end

return DataManager
