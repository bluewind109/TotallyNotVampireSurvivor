extends Node

enum EXIT_CONDITION {None, Wave_Duration, Kill_All}

enum ENEMY_TYPE {Cube, Eye, EyeGhost, EyeLeg, Triple}

enum ENEMY_RANK {Normal, Elite, Miniboss, Boss}

var DICT_ENEMY_MODIFIER: Dictionary[String, EnemyModifier] = {
	# General
	"Health": EnemyModifier.new(
		MODIFIER_ID.Health,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15], # base power
		[0.05], # additional power per level
	),
	"Damage": EnemyModifier.new(
		MODIFIER_ID.Damage,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15],
		[0.05],
	),
	# Elite
	"CircularBombs": EnemyModifier.new(
		MODIFIER_ID.CircularBombs,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.1],
		[0],
	),
	"FireRing": EnemyModifier.new(
		MODIFIER_ID.FireRing,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.1],
		[0],
	),
	"IceRing": EnemyModifier.new(
		MODIFIER_ID.IceRing,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25, 0.05], # slow power + damage power
		[0],
	),
	"TwinReincarnation": EnemyModifier.new(
		MODIFIER_ID.TwinReincarnation,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25], # %HP base of original on split
		[0],
	),
	"Barrier": EnemyModifier.new(
		MODIFIER_ID.Barrier,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25], # % of max HP
		[0],
	),
	# Boss
	"OrbitProjectile": EnemyModifier.new(
		MODIFIER_ID.OrbitProjectile,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.1],
		[0],
	),
	"SpeedSurge": EnemyModifier.new(
		MODIFIER_ID.SpeedSurge,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.5, 5.0, 10.0], # base power + duration + cooldown
		[0.05],
	),
	"Armored": EnemyModifier.new(
		MODIFIER_ID.Armored,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.25, 20.0], # base power + cooldown
		[0.05],
	),
	"SpeedAura": EnemyModifier.new(
		MODIFIER_ID.SpeedAura,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.25], # base power
		[0],
	),
}

enum ENEMY_MODIFIER_TYPE {General, Elite, Boss}

enum MODIFIER_ID
{
	# General modifiers
	Health = 0,
	Damage,
	# Elite Modifiers
	CircularBombs = 50,
	FireRing,
	IceRing,
	TwinReincarnation,
	Barrier,
	# Boss modifiers
	OrbitProjectile = 100,
	SpeedSurge,
	Armored,
	AuraSpeed,
	SpeedAura,
}

enum MODIFIER_LEVEL_CONDITION
{
	General = 10,
	Elite = 20,
	Boss = 30,
}

var mod_rng = RandomNumberGenerator.new()
func get_all_general_modifiers() -> Array[EnemyModifier]:
	var filtered: Array[EnemyModifier] = []
	for key in DICT_ENEMY_MODIFIER.keys:
		if (DICT_ENEMY_MODIFIER[key].mod_type == ENEMY_MODIFIER_TYPE.General):
			filtered.append(DICT_ENEMY_MODIFIER[key])
	return filtered

func get_all_elite_modifiers() -> Array[EnemyModifier]:
	var filtered: Array[EnemyModifier] = []
	for key in DICT_ENEMY_MODIFIER.keys:
		if (DICT_ENEMY_MODIFIER[key].mod_type == ENEMY_MODIFIER_TYPE.Boss):
			filtered.append(DICT_ENEMY_MODIFIER[key])
	return filtered

func get_all_boss_modifiers() -> Array[EnemyModifier]:
	var filtered: Array[EnemyModifier] = []
	# TODO
	return filtered

func get_random_general_modifier() -> String:
	return get_random_modifier(ENEMY_MODIFIER_TYPE.General)

func get_random_elite_modifier() -> String:
	return get_random_modifier(ENEMY_MODIFIER_TYPE.Boss)

func get_random_modifier(_type: ENEMY_MODIFIER_TYPE) -> String:
	mod_rng.randomize()
	var weighted_sum = 0
	var filtered_mod_type = _type
	var result_key: String = ""

	for n in DICT_ENEMY_MODIFIER:
		if (DICT_ENEMY_MODIFIER[n].mod_type == filtered_mod_type):
			weighted_sum += DICT_ENEMY_MODIFIER[n].mod_weight

	var item = mod_rng.randi_range(0, weighted_sum)

	var result_found: bool = false
	for n in DICT_ENEMY_MODIFIER:
		if (DICT_ENEMY_MODIFIER[n].mod_type == filtered_mod_type):
			if (result_found == false and item < DICT_ENEMY_MODIFIER[n]):
				result_key = n
				result_found = true
				continue
			item -= DICT_ENEMY_MODIFIER[n]
			DICT_ENEMY_MODIFIER[n].increase_weight()
	
	print("get_random_general_modifier: %s", % result_key)
	return result_key

func get_modifier_effect(_mod_id: MODIFIER_ID) -> void:
	pass