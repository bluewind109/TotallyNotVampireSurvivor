extends Node

enum EXIT_CONDITION {None, Wave_Duration, Kill_All}

enum ENEMY_TYPE {Cube, Eye, EyeGhost, EyeLeg, Triple}

enum ENEMY_RANK {Normal, Elite, Miniboss, Boss}

var DICT_ENEMY_MODIFIER_PATH: Dictionary[MODIFIER_ID, PackedScene] = {
	MODIFIER_ID.Barrier: preload("res://scenes/common/component_Barrier.tscn"),
	MODIFIER_ID.CircularBombs: preload("res://scenes/character/enemy/enemy_modifier/component_EM_CircularBomb.tscn"),
	MODIFIER_ID.FireRing: preload("res://scenes/character/enemy/enemy_modifier/component_EM_FireRing.tscn"),
	MODIFIER_ID.IceRing: preload("res://scenes/character/enemy/enemy_modifier/component_EM_IceRing.tscn"),
}

var DICT_ENEMY_MODIFIER: Dictionary[MODIFIER_ID, EnemyModifierData] = {
	# General
	MODIFIER_ID.Health: EnemyModifierData.new(
		MODIFIER_ID.Health,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15], # base power
		[0.05], # additional power per level
	),
	MODIFIER_ID.Damage: EnemyModifierData.new(
		MODIFIER_ID.Damage,
		ENEMY_MODIFIER_TYPE.General,
		MODIFIER_LEVEL_CONDITION.General,
		[0.15],
		[0.05],
	),
	# Elite
	MODIFIER_ID.CircularBombs: EnemyModifierData.new(
		MODIFIER_ID.CircularBombs,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.1],
		[0],
	),
	MODIFIER_ID.FireRing: EnemyModifierData.new(
		MODIFIER_ID.FireRing,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.1],
		[0],
	),
	MODIFIER_ID.IceRing: EnemyModifierData.new(
		MODIFIER_ID.IceRing,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25, 0.05], # slow power + damage power
		[0],
	),
	MODIFIER_ID.TwinReincarnation: EnemyModifierData.new(
		MODIFIER_ID.TwinReincarnation,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25], # %HP base of original on split
		[0],
	),
	MODIFIER_ID.Barrier: EnemyModifierData.new(
		MODIFIER_ID.Barrier,
		ENEMY_MODIFIER_TYPE.Elite,
		MODIFIER_LEVEL_CONDITION.Elite,
		[0.25], # % of max HP
		[0],
	),
	# Boss
	MODIFIER_ID.OrbitProjectile: EnemyModifierData.new(
		MODIFIER_ID.OrbitProjectile,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.1],
		[0],
	),
	MODIFIER_ID.SpeedSurge: EnemyModifierData.new(
		MODIFIER_ID.SpeedSurge,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.5, 5.0, 10.0], # base power + duration + cooldown
		[0.05],
	),
	MODIFIER_ID.Armored: EnemyModifierData.new(
		MODIFIER_ID.Armored,
		ENEMY_MODIFIER_TYPE.Boss,
		MODIFIER_LEVEL_CONDITION.Boss,
		[0.25, 20.0], # base power + cooldown
		[0.05],
	),
	MODIFIER_ID.SpeedAura: EnemyModifierData.new(
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
func get_all_general_modifiers() -> Array[EnemyModifierData]:
	var filtered: Array[EnemyModifierData] = []
	for key in DICT_ENEMY_MODIFIER.keys():
		if (DICT_ENEMY_MODIFIER[key].mod_type == ENEMY_MODIFIER_TYPE.General):
			filtered.append(DICT_ENEMY_MODIFIER[key])
	return filtered

func get_all_elite_modifiers() -> Array[EnemyModifierData]:
	var filtered: Array[EnemyModifierData] = []
	for key in DICT_ENEMY_MODIFIER.keys():
		if (DICT_ENEMY_MODIFIER[key].mod_type == ENEMY_MODIFIER_TYPE.Boss):
			filtered.append(DICT_ENEMY_MODIFIER[key])
	return filtered

func get_all_boss_modifiers() -> Array[EnemyModifierData]:
	var filtered: Array[EnemyModifierData] = []
	# TODO
	return filtered

func get_random_general_modifier() -> MODIFIER_ID:
	return get_random_modifier(ENEMY_MODIFIER_TYPE.General)

func get_random_elite_modifier() -> MODIFIER_ID:
	return get_random_modifier(ENEMY_MODIFIER_TYPE.Boss)

func get_random_modifier(_type: ENEMY_MODIFIER_TYPE) -> MODIFIER_ID:
	mod_rng.randomize()
	var weighted_sum = 0
	var filtered_mod_type = _type
	var result_key

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
