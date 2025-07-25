extends Node

const UPGRADE_TEXT_DATA: Dictionary[String, String] = {
	UPGRADE_ID.Damage: "Damage",
	UPGRADE_ID.ProjectileSpeed: "Projectile Speed",
	UPGRADE_ID.Health: "Health",
	UPGRADE_ID.MoveSpeed: "Movement Speed",
	UPGRADE_ID.Firerate: "Attack Speed",
	UPGRADE_ID.KnockbackStrength: "Knockback Strength",
	UPGRADE_ID.PierceStrength: "Pierce Strength",
	UPGRADE_ID.MaxAmmo: "Max Ammo",
	UPGRADE_ID.CritChance: "Critical Chance",
	UPGRADE_ID.CritDmg: "Critical Damage",
	UPGRADE_ID.ReloadTime: "Reload Time",
	"Accuracy": "Accuracy",
	"AttackRange": "Attack Range",
}

enum UPGRADE_TYPE {
	Damage,
	ProjectileSpeed,
	Health,
	MoveSpeed,
	Firerate,
	KnockbackStrength,
	PierceStrength,
	MaxAmmo,
	CritChance,
	CritDmg,
	ReloadTime,
}

const UPGRADE_ID: Dictionary[String, String] = {
	"Damage": "Damage",
	"ProjectileSpeed": "ProjectileSpeed",
	"Health": "Health",
	"MoveSpeed": "MoveSpeed",
	"Firerate": "Firerate",
	"KnockbackStrength": "KnockbackStrength",
	"PierceStrength": "PierceStrength",
	"MaxAmmo": "MaxAmmo",
	"CritChance": "CritChance",
	"CritDmg": "CritDmg",
	"ReloadTime": "ReloadTime",
}

## Set what rarity that the upgrade can possibly show
const UPGRADE_AVAILABLE_RARITY: Dictionary[String, Array] = {
	UPGRADE_ID.Damage: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.ProjectileSpeed: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.Health: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.MoveSpeed: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.Firerate: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.KnockbackStrength: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.PierceStrength: 
		[RARITY.Rare], # only available as Rare
	UPGRADE_ID.MaxAmmo: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.CritChance: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.CritDmg: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
	UPGRADE_ID.ReloadTime: 
		[RARITY.Common, RARITY.Uncommon, RARITY.Rare, RARITY.Epic, RARITY.Legendary],
}

enum RARITY {
	Common,
	Uncommon,
	Rare,
	Epic,
	Legendary
}

const RARITY_COLOR: Array[Color] = [
	Color(0.75, 0.75, 0.75, 1), # white-ish grey
	Color(0, 0.392157, 0, 1), # green
	Color(0, 0.74902, 1, 1), # blue,
	Color(0.576471, 0.439216, 0.858824, 1), # purple
	Color(1, 0.647059, 0, 1) # orange
]

const RARITY_ID: Dictionary[String, String] = {
	"Common": "Common",
	"Uncommon": "Uncommon",
	"Rare": "Rare",
	"Epic": "Epic",
	"Legendary": "Legendary",
}

const RARITY_WEIGHT: Dictionary[String, float] = {
	RARITY_ID.Common: 50,
	RARITY_ID.Uncommon: 25,
	RARITY_ID.Rare: 15,
	RARITY_ID.Epic: 4,
	RARITY_ID.Legendary: 1,
}

var rng = RandomNumberGenerator.new()
func get_rarity() -> String:
	rng.randomize()
	var weighted_sum = 0
	for n: String in RARITY_WEIGHT:
		weighted_sum += RARITY_WEIGHT[n]
	
	var item = rng.randi_range(0, weighted_sum)

	for n in RARITY_WEIGHT:
		if (item < RARITY_WEIGHT[n]):
			return n
		item -= RARITY_WEIGHT[n]
	
	print("get_rarity return default")
	return "Common"

func get_rarities(amount: int) -> Array[String]:
	var rarities: Array[String]
	while (rarities.size() < amount):
		var idx = UpgradeConfig.get_rarity()
		if (rarities.has(idx)): continue
		rarities.append(idx)
	return rarities

func get_random_upgrade():
	rng.randomize()
	
	var upgrade_idx = rng.randi_range(0, UPGRADE_TYPE.size() - 1)
	return UPGRADE_TYPE.values()[upgrade_idx]

func get_random_upgrade_with_rarity(rarity: String):
	rng.randomize()
	var result: int = -1

	while (result < 0):
		var upgrade_idx = rng.randi_range(0, UPGRADE_TYPE.size() - 1)
		# print(UPGRADE_TYPE.keys()[upgrade_idx], " - ", rarity)
		if (not check_upgrade_rarity(UPGRADE_TYPE.keys()[upgrade_idx], rarity)):
			continue
		result = UPGRADE_TYPE.values()[upgrade_idx]
		# print("get_random_upgrade_with_rarity ", result)
	return result

func get_random_upgrades(amount: int):
	var upgrades: Array[int]
	while (upgrades.size() < amount):
		var idx = UpgradeConfig.get_random_upgrade()
		if (upgrades.has(idx)): continue
		upgrades.append(idx)
	return upgrades

func get_random_upgrades_with_rarity(amount: int, rarities: Array[String]):
	var upgrades: Array[int]
	var count = 0
	while (count < amount):
		var idx = UpgradeConfig.get_random_upgrade_with_rarity(rarities[count])
		# print("get_random_upgrades_with_rarity idx ", idx)
		if (upgrades.has(idx)): 
			# print("get_random_upgrades_with_rarity ", upgrades.has(idx))
			continue
		# print("get_random_upgrades_with_rarity ", upgrades)
		upgrades.append(idx)
		count += 1

	print("get_random_upgrades_with_rarity ", upgrades)
	return upgrades

func check_upgrade_rarity(val: String, rarity: String):
	# print(UPGRADE_AVAILABLE_RARITY.get(val))
	var available_rarities = UPGRADE_AVAILABLE_RARITY.get(val).duplicate()
	var converted_to_str_arr: Array[String]
	for n in available_rarities:
		converted_to_str_arr.append(RARITY.keys()[n])
	# print("check_upgrade_rarity ", converted_to_str_arr)
	# print("check_upgrade_rarity ", converted_to_str_arr.has(rarity))
	return converted_to_str_arr.has(rarity)

func get_rarity_color(_id: String) -> Color:
	match(_id):
		RARITY_ID.Common:
			return RARITY_COLOR[RARITY.Common]
		RARITY_ID.Uncommon:
			return RARITY_COLOR[RARITY.Uncommon]
		RARITY_ID.Rare:
			return RARITY_COLOR[RARITY.Rare]
		RARITY_ID.Epic:
			return RARITY_COLOR[RARITY.Epic]
		RARITY_ID.Legendary:
			return RARITY_COLOR[RARITY.Legendary]

	print("get_rarity_color return default")
	return RARITY_COLOR[0]
