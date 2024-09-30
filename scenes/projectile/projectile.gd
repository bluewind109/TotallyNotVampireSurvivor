extends Area2D
class_name Projectile

var direction: Vector2 = Vector2.RIGHT
var speed: float = 200
var damage: float = 1

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		#body.knockback = direction * 75
		body.knockback += direction * 75 # stronger knockback effect


func _on_screen_exited() -> void:
	queue_free()
