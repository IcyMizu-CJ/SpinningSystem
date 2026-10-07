local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreatureConfig = require(ReplicatedStorage.Shared.Systems.Configs.CreatureConfig)
local Types = require(ReplicatedStorage.Shared.Types)
local Id = require(ReplicatedStorage.Shared.Utility.Id)


local Creatures = CreatureConfig.Contents

local RNG = {} 

local function adjustedOdds(Odds: number,PlayerLuck: number)
	return Odds / math.sqrt(PlayerLuck)
end

function RNG.CreatureRoll(PlayerLuck: number): Types.CreatureConfig
	--// Successfull creature rolls
	local Success = {}
	for _, Creature:Types.CreatureConfig in Creatures do
		local Odds = adjustedOdds(Creature.odds,PlayerLuck)
		local Roll = Random.new():NextInteger(1, Odds)
		if Roll == 1 then
			table.insert(Success,Creature)
		end
	end

	if #Success == 0 then
		return Creatures[CreatureConfig.Default]
	end

	table.sort(Success,function(a, b): boolean  
		return a.odds > b.odds
	end)

	return Success[1]
end

function RNG:CreateStep(Lucks: any)
	local BonusLuck = Lucks.BonusLuck
	local WildLuck = Lucks.WildLuck
	local PlayerLuck = Lucks.PlayerLuck
	local BonusRng = Random.new():NextInteger(1, BonusLuck)
	local WildRng = Random.new():NextInteger(1, WildLuck)
	if BonusRng == 1  then
			return {
				type = 'Bonus'
			}
		elseif WildRng == 1 then
			local RandomMulti = Random.new():NextInteger(1, 100)
			return {
				type = 'Wild',
				wildMulti = RandomMulti
			}
		else
			local Creature = RNG.CreatureRoll(PlayerLuck):: Types.CreatureConfig
			return {
				type = 'Creature',
				creatureId = Creature.id,
			}
		end
end

function RNG:CreateJob(_Player: Player,Lucks: any)
	local BonusLuck = Lucks.BonusLuck
	local WildLuck = Lucks.WildLuck
	local PlayerLuck = Lucks.PlayerLuck

	local Job = {
		id = Id:Create('Job'),
		steps = {

		}
	}

	local totalBonus = 0
	local Resolved = false
	local Wild = false
	repeat
		local BonusRng = Random.new():NextInteger(1, BonusLuck)
		local WildRng = Random.new():NextInteger(1, WildLuck)

		if totalBonus == 3 then
			Resolved = true
		end

		if BonusRng == 1 and not Wild and not Resolved then
			table.insert(Job.steps,{
				type = 'Bonus'
			}:: Types.JobStep)
			totalBonus += 1
		elseif WildRng == 1 and not Wild and not Resolved then
			local RandomMulti = Random.new():NextInteger(1, 100)
			table.insert(Job.steps,{
				type = 'Wild',
				wildMulti = RandomMulti
			}:: Types.JobStep)
			Wild = RandomMulti
		else
			local Creature = RNG.CreatureRoll(PlayerLuck * (Wild or 1)):: Types.CreatureConfig
			table.insert(Job.steps,{
				type = 'Creature',
				creatureId = Creature.id,
			}:: Types.JobStep)
			Resolved = true
		end

	until Resolved

	return Job
end

return RNG
