extends Area2D
class_name PlayerHitbox

@onready var collision: CollisionShape2D = $Collision

func toggle_collision(val: bool):
	collision.set_deferred("disabled", val)

func _on_body_entered(body: Node2D) -> void:
	# print("[PlayerHitbox] _on_body_entered")
	SignalManager.on_player_hit.emit(body.damage)

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("ProjectileEnemy")):
		area = area as ProjectileEnemy
		SignalManager.on_player_hit.emit(area.damage)
	
