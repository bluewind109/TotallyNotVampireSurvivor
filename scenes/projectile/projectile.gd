extends Area2D
class_name Projectile

var direction: Vector2 = Vector2.RIGHT
var speed: float = 200
var damage: float = 1

func init_projectile(_position: Vector2, _direction: Vector2, _speed: float, _damage: float) -> void:
	position = _position
	direction = _direction
	speed = _speed
	damage = _damage
	pass

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
	# if body.has_method("take_damage"):
		print("[projectile] _on_body_entered: ", damage)
		body = body as Enemy
		body.take_damage(damage)
		#body.knockback = direction * 75
		body.add_knockback(direction * 75) # stronger knockback effect


func _on_screen_exited() -> void:
	queue_free()
