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
	# var mod_count = arr_modifiers_general.size()
	if (is_general_modifier(level)):
		add_new_modifier(SpawnConfig.ENEMY_MODIFIER_TYPE.General)

	if (is_elite_modifier(level)):
		add_new_modifier(SpawnConfig.ENEMY_MODIFIER_TYPE.Elite)


func add_new_modifier(_type: SpawnConfig.ENEMY_MODIFIER_TYPE) -> void:
	print("[EnemyModifierManager] add_new_modifier ", _type)
	match _type:
		SpawnConfig.ENEMY_MODIFIER_TYPE.General:
			add_modifier_general()
		SpawnConfig.ENEMY_MODIFIER_TYPE.Elite:
			add_modifier_elite()
		_:
			pass

func add_modifier_general() -> void:
	var mod_key: SpawnConfig.MODIFIER_ID = SpawnConfig.get_random_general_modifier()
	print("[EnemyModifierManager] add_modifier_general ", mod_key)
	# var mod: EnemyModifierData = SpawnConfig.DICT_ENEMY_MODIFIER[mod_key].duplicate()
	# arr_modifiers_general.append(mod)

func add_modifier_elite() -> void:
	var mod_key: SpawnConfig.MODIFIER_ID = SpawnConfig.get_random_elite_modifier()
	print("[EnemyModifierManager] add_modifier_elite ", mod_key)
	# var mod = SpawnConfig.DICT_ENEMY_MODIFIER[mod_key].duplicate()
	# arr_modifiers_elite.append(mod)

func is_elite_modifier(input: int):
	var result = input % SpawnConfig.MODIFIER_LEVEL_CONDITION.Elite
	# print("is odd %s" % result)
	return result == 0

func is_general_modifier(input: int):
	var result = input % SpawnConfig.MODIFIER_LEVEL_CONDITION.General
	return result == 0