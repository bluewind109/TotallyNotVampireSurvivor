extends Area2D
class_name PlayerHitbox

@onready var collision: CollisionShape2D = $Collision

func toggle_collision(val: bool):
	collision.set_deferred("disabled", val)

func _on_body_entered(body: Node2D) -> void:
	SignalManager.on_player_hit.emit(body.damage)
	pass # Replace with function body.
