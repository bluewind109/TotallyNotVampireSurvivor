extends EnemyModifier
class_name component_EM_Barrier

@export var sprite: Sprite2D

var health: float = 10.0

var is_active: bool = false

func _ready() -> void:
	pass

func init(_health: float) -> void:
	health = _health
	is_active = true

func absorb_damage(damage: float) -> void:
	health = health - damage
	health = maxf(health, 0)

	# TODO the barrier flashes white color if getting hit
	# instead of the target
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(0.799, 0.146, 0.044), 0.2)
	tween.chain().tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)

	if (health <= 0):
		remove_barrier()

func remove_barrier():
	is_active = false
	# TODO hide barrier sprite
