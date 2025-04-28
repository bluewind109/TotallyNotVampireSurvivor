extends Node

enum UPGRADE_TYPE {
	Damage,
	ProjectileSpeed,
	Health,
	MoveSpeed,
	Firerate,
	KnockbackStrength,
	PierceStrength
}

enum RARITY {
	Common,
	Uncommon,
	Rare,
	Epic,
	Legendary
}

const RARITY_WEIGHT = {
	"Common": 50,
	"Uncommon": 25,
	"Rare": 15,
	"Epic": 4,
	"Legendary": 1,
}

var rng = RandomNumberGenerator.new()
func get_rarity():
	rng.randomize()
	var weighted_sum = 0
	for n in RARITY_WEIGHT:
		weighted_sum += RARITY_WEIGHT[n]
	
	var item = rng.randi_range(0, weighted_sum)

	for n in RARITY_WEIGHT:
		if (item < RARITY_WEIGHT[n]):
			return n
		item -= RARITY_WEIGHT[n]

func get_random_upgrade():
	rng.randomize()
	
	var upgrade_idx = rng.randi_range(0, UPGRADE_TYPE.size() - 1)
	return UPGRADE_TYPE.values()[upgrade_idx]

func get_random_upgrades(amount: int):
	var upgrades: Array[int]
	while (upgrades.size() < amount):
		var idx = UpgradeConfig.get_random_upgrade()
		if (upgrades.has(idx)): continue
		upgrades.append(idx)
	return upgrades