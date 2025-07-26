extends Resource
class_name EnemyModifierData

var mod_id: SpawnConfig.MODIFIER_ID
var mod_type: SpawnConfig.ENEMY_MODIFIER_TYPE
var mod_level_condition: SpawnConfig.MODIFIER_LEVEL_CONDITION = SpawnConfig.MODIFIER_LEVEL_CONDITION.General
var mod_values: Array[float] = [] # [0] is always effect power
var mod_incremental: Array[float] = [] # if empty or zero, it isn't affected by player's level

var mod_level: int = 0
var mod_weight: float = 1.0

const WEIGHT_INCREASE_RATE: float = 1.5

func _init(
	_id: SpawnConfig.MODIFIER_ID, 
	_type: SpawnConfig.ENEMY_MODIFIER_TYPE,
	_level_condition: SpawnConfig.MODIFIER_LEVEL_CONDITION,
	_values: Array[float],
	_incremental: Array[float],
	_weight: float =  1.0,
) -> void:
	mod_id = _id
	mod_type = _type
	mod_level_condition = _level_condition
	mod_values = _values
	mod_incremental = _incremental

func get_mod_effect_final() -> void:
	var _mod_final_effect: float = mod_values[0] + mod_incremental[0] * mod_level

func increase_weight() -> void:
	mod_weight *= WEIGHT_INCREASE_RATE
