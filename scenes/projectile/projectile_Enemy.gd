extends Area2D
class_name ProjectileEnemy

var direction: Vector2 = Vector2.RIGHT
var speed: float = 200 # edit in enemy script
var damage: float = 1 # edit in enemy script

func init_projectile(
	_position: Vector2, 
	_direction: Vector2, 
	_speed: float, 
	_damage: float
) -> void:
	position = _position
	direction = _direction
	speed = _speed
	damage = _damage
	pass

func _physics_process(delta: float) -> void:
	position += direction * speed * delta * GameGlobal.slow_mo_multiplier

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
