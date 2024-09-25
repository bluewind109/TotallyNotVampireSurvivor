class_name BaseItem

extends Area2D

@onready var sprite_container = $SpriteContainer
@onready var spawn_timer = $SpawnTimer

var _player_ref: Player = null
var item_type: String
var is_in_loot_range: bool = false
var can_be_loot: bool = false

func _ready():
	_player_ref = get_tree().get_first_node_in_group("Player")
	call_deferred("wait_for_physics")

func wait_for_physics() -> void:
	await get_tree().physics_frame
	set_physics_process(true)
		
func consume() -> void:
	print("consume")
	queue_free()

func _on_spawn_timer_timeout():
	can_be_loot = true

#func _on_body_entered(body):
	#queue_free()
