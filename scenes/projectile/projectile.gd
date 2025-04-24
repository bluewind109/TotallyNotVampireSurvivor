extends Area2D
class_name Projectile

var direction: Vector2 = Vector2.RIGHT
var speed: float = 200
var damage: float = 1
var knockback: float = 20.0
var pierce_strength: int = 1

var pierce_count: int = 0 ## Number of enemies that have interacted with the projectile

func init_projectile(
	_position: Vector2, 
	_direction: Vector2, 
	_speed: float, 
	_damage: float,
	_kb_strength: float,
	_pierce_str: int
):
	position = _position
	direction = _direction
	speed = _speed
	damage = _damage
	knockback = _kb_strength
	pierce_strength = _pierce_str
	pass

func _physics_process(delta: float) -> void:
	# print("[Profile] speed: ", speed)
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
	# if body.has_method("take_damage"):
		# print("[projectile] _on_body_entered: ", damage)
		body = body as Enemy
		body.take_damage(damage)
		#body.knockback = direction * 75
		body.add_knockback(direction * knockback) # stronger knockback effect
		pierce_count += 1
		if (pierce_count >= pierce_strength): queue_free()


func _on_screen_exited() -> void:
	queue_free()
