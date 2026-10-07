
export type SoundManager = {
	PlaySound: (SoundName: string) -> (),
}

export type SettingsData = {
	[string]: boolean,
}

export type JobStep = 
	{
		type: 'Creature' | 'Bonus' | 'Wild',
		creatureId: string?,
		wildMulti: number?,
	}

export type JobRoll = {
	id: string,
	steps: {
		JobStep
	}
}

export type RarityConfig = {
	luckInfluence: number,
	color: Color3,
	gradient: ColorSequence
}

export type CreatureConfig = {
	id: string,
	odds: number,
	rarity: string,
}

export type PlayerData = {
	Creatures: {},
	Index: {[string]: boolean},
	Stats: {
		TotalRolls: {[string]: number}
	},
	RollData: {
		Luck: number,
		RollSpeed: number,
	},
	Settings: {
		AutoRoll: boolean
	},
	Upgrades: {
		Mutations: number,
	},
	Skins: {
		LuckBuilding: string,
	},
}

export type SnapshotSyncData = {
	RollSpeed: number,
	PlayerLuck: number,
	AutoRoll: boolean
}

export type SessionData = {
	RollData: {
		Active: boolean,
		RollCount: number,
		Queue: {JobRoll}
	}
}

export type BuildingFolder = {
	Spawn: Part,
	Model: Folder, -- Holds the building model
}

export type PlotInstance = {
	SpawnLocation: SpawnLocation,
	Buildings: {[string]: BuildingFolder}, 
	PlotIndicator: Part&{BillboardGui: BillboardGui&{Text1: TextLabel,Text2: TextLabel}}
}

export type BuildingConfig = {
	Id: string,
	DefaultSkin: string,
	UpgradeCategory: string
}


return {}
