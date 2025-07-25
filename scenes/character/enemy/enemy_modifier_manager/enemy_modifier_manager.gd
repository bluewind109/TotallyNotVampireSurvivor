extends Node
## This component stores currently active modifiers in the game
class_name EnemyModifierManager

var arr_modifiers_general: Array[EnemyModifier]
var arr_modifiers_elite: Array[EnemyModifier]

func _ready() -> void:
	SignalManager.on_level_up.connect(check_add_modifier)

func get_current_modifiers() -> void:
	pass

func check_add_modifier(level: int) -> void:
	var mod_count = arr_modifiers_general.size()
	var level_div: int = level / SpawnConfig.MODIFIER_LEVEL_CONDITION.General
	print("check_add_modifier level_div: %s", % level_div)
	if (level_div > mod_count): # add new mod
		pass

func add_new_modifier(_type: SpawnConfig.ENEMY_MODIFIER_TYPE) -> void:
	match _type:
		SpawnConfig.ENEMY_MODIFIER_TYPE.General:
			add_modifier_general()
		SpawnConfig.ENEMY_MODIFIER_TYPE.Elite:
			add_modifier_elite()
		_:
			pass

func add_modifier_general() -> void:
	var mod_key: String = SpawnConfig.get_random_general_modifier()
	var mod = SpawnConfig.DICT_ENEMY_MODIFIER[mod_key].duplicate()
	arr_modifiers_general.append(mod)

func add_modifier_elite() -> void:
	var mod_key: String = SpawnConfig.get_random_elite_modifier()
	var mod = SpawnConfig.DICT_ENEMY_MODIFIER[mod_key].duplicate()
	arr_modifiers_elite.append(mod)
