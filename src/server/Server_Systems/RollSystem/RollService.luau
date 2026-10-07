local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataManager = require(ServerScriptService.Server.Server_Systems.Data.DataManager)
local ServerSignals = require(ServerScriptService.Server.Server_Systems.Data.ServerSignals)
local SessionData = require(ServerScriptService.Server.Server_Systems.Data.SessionData)
local LuckService = require(ServerScriptService.Server.Server_Systems.Luck.LuckService)
local packet = require(ReplicatedStorage.Packages.packet)
local RNG = require(ReplicatedStorage.Shared.Systems.RollSystem.RNG)
local Types = require(ReplicatedStorage.Shared.Types)



local RequestRoll = packet("RequestRoll")
local SendRoll = packet('SendRoll',packet.Any:: {Types.JobRoll})
local ResolveRoll = packet('ResolveRoll')

local ChangeAutoRollState = packet('ChangeAutoRollState')


local RollService = {}


function RollService:Init(_Services)

	ServerSignals.DataLoaded:Connect(function(Player: Player, plrdata: Types.PlayerData)
		if plrdata.Settings.AutoRoll == true then
			self:TryRequestRoll(Player)
		end
	end)

	RequestRoll.OnServerEvent:Connect(function(Player: Player)
		local AutoRoll = DataManager:GetAutoRoll(Player)

		if AutoRoll == nil or AutoRoll then
			return
		end

		self:TryRequestRoll(Player)
		
	end)

	ResolveRoll.OnServerEvent:Connect(function(Player: Player)
		SessionData:SetRollActive(Player, false)
		SessionData:ClearJobQueue(Player)

		local AutoRoll = DataManager:GetAutoRoll(Player)
		if AutoRoll then
			self:TryRequestRoll(Player)
		end
	end)

	ChangeAutoRollState.OnServerEvent:Connect(function(Player: Player)
		local AutoRoll = DataManager:GetAutoRoll(Player)
		if AutoRoll == nil then
			warn(`Could not change AutoRoll setting for player: {Player}`)
			return
		end
		local Set = DataManager:SetAutoRoll(Player, not AutoRoll):: boolean
		if not Set then
			warn(`Could not change AutoRoll setting for player: {Player}`)
			return
		end 
		self:TryRequestRoll(Player)
	end)
end

function RollService:TryRequestRoll(Player: Player)
	local SessionProfile = SessionData:GetSessionData(Player):: Types.SessionData

	if not SessionProfile then
		warn(`Rolling failed for {Player.Name} no sessiondata found`)
		return
	end

	if SessionProfile.RollData.Active then
		return
	end

	if #SessionProfile.RollData.Queue <= 0 then
		RollService:RequestRoll(Player,SessionProfile.RollData.RollCount)
	end

	RollService:Roll(Player,SessionProfile.RollData.Queue)
end

function RollService:RequestRoll(Player: Player,RollCount: number)
	for _ = 1, RollCount do
		local BonusLuck = SessionData:GetBonusLuck(Player)
		local WildLuck = SessionData:GetWildLuck(Player)
		local PlayerLuck = LuckService:GetLuck(Player)
		local Job = RNG:CreateJob(Player,{BonusLuck = BonusLuck,WildLuck = WildLuck,PlayerLuck = PlayerLuck}) :: Types.JobRoll
		SessionData:AddToJobQueue(Player, Job)
	end
end

function RollService:Roll(Player: Player,Queue: {Types.JobRoll})
	SessionData:SetRollActive(Player, true)
	SendRoll:FireClient(Player, Queue)
end

return RollService
