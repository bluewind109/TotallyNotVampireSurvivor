@icon("res://resources/icons/16x16/shield.png")
extends Node2D
class_name component_Barrier

@export var component_health: Component_Health
@export var sprite: Sprite2D

var is_active: bool = false:
	set(value):
		is_active = value
		sprite.visible = value

var can_barrier_recover: bool = false

func _ready() -> void:
	is_active = false

func init(_health: float) -> void:
	component_health.init(_health)
	is_active = true

func absorb_damage(amount: float) -> void:
	if (not is_active): return
	if (component_health.health <= 0): return

	# print("absorb_damage")
	component_health.take_damage(amount)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0.1), 0.2)
	tween.chain().tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)

func remove_barrier():
	is_active = false
