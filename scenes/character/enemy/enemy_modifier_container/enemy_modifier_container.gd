@icon("res://resources/icons/16x16/model_edit.png")
extends Node2D
class_name EnemyModifierContainer

var dict_modifiers: Dictionary[SpawnConfig.MODIFIER_ID, EnemyModifier]

func _ready() -> void:
	pass

func add_modifier(_modifier: EnemyModifier):
	# check if modifier already exist
	if (has_modifier(_modifier.em_id)): return

	# TODO add modifier to this container
	dict_modifiers.set(_modifier.em_id, _modifier)
	var mod_instance: EnemyModifier
	# mod_instance = list_enemy_type[SpwnConfig.ENEMY_TYPE.Cube].instantiate() as EnemyCube
	self.add_child.call_deferred(null)

func has_modifier(_em_id: SpawnConfig.MODIFIER_ID) -> bool:
	if (dict_modifiers.size() <= 0): return false

	# TODO check if this entity has X modifier
	return false
