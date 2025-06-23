extends Node

enum EXIT_CONDITION {None, Wave_Duration, Kill_All}

enum ENEMY_TYPE {Cube, Eye, EyeGhost, EyeLeg, Triple}

enum ENEMY_RANK {Normal, Elite, Miniboss, Boss}

var DICT_ENEMY_MODIFIER: Dictionary[String, EnemyModifier] = {
	"Health": EnemyModifier.new(
		MODIFIER_ID.Health,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15],
		[0.05],
	),
	"Damage": EnemyModifier.new(
		MODIFIER_ID.Damage,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15],
		[0.05],
	),
	"Speed": EnemyModifier.new(
		MODIFIER_ID.Speed,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15],
		[0.05],
	),
	"OrbitProjectile": EnemyModifier.new(
		MODIFIER_ID.OrbitProjectile,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.1],
		[0.05],
	),
	"SpeedSurge": EnemyModifier.new(
		MODIFIER_ID.SpeedSurge,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.5, 5.0, 10.0], # effect power + duration + cooldown
		[0.05],
	),
	"Armored": EnemyModifier.new(
		MODIFIER_ID.Armored,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25, 20.0], # effect power + cooldown
		[0.05],
	),
}

enum ENEMY_MODIFIER_TYPE {General, Elite}

enum MODIFIER_ID
{
	# General modifiers
	Health = 0,
	Damage,
	Speed,
	# Elite modifiers
	OrbitProjectile = 100,
	SpeedSurge,
	Armored,
	AuraSpeed,
}

enum MODIFIER_LEVEL_CONDITION
{
	General = 10,
	Elite = 20,
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
		if (DICT_ENEMY_MODIFIER[key].mod_type == ENEMY_MODIFIER_TYPE.Elite):
			filtered.append(DICT_ENEMY_MODIFIER[key])
	return filtered

func get_all_boss_modifiers() -> Array[EnemyModifier]:
	var filtered: Array[EnemyModifier] = []
	# TODO
	return filtered

func get_random_general_modifier() -> String:
	return get_random_modifier(ENEMY_MODIFIER_TYPE.General)

func get_random_elite_modifier() -> String:
	return get_random_modifier(ENEMY_MODIFIER_TYPE.Elite)

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