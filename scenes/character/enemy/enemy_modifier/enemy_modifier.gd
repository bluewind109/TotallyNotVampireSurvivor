extends Node2D
class_name EnemyModifier

@export var em_id: SpawnConfig.MODIFIER_ID 

var mod_data: EnemyModifierData

func _init(_mod_data: EnemyModifierData) -> void:
	mod_data = _mod_data

func _ready() -> void:
	pass

func update_modifier(_mod_data: EnemyModifierData):
	# TODO [Khanh] update modifier to existing entity
	pass