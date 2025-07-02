extends ProjectileEnemy
class_name ProjectileArcEnemy

var throw_angle_degrees: float
const _gravity: float = 9.8
var time: float = 0.0

var initial_position: Vector2

var z_axis: float = 0 # simulate z-axis
var is_launch: bool = false
var has_landed: bool = false

var time_mult: float = 8.0

@export var projectile_sprite: Sprite2D
@export var despawn_timer: Timer

func _physics_process(delta: float) -> void:
	if (has_landed): return

	time += delta * time_mult * GameGlobal.slow_mo_multiplier
	if (is_launch):
		z_axis = speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * _gravity * pow(time, 2)

		# if projectile has not touched the ground yet
		if (z_axis > 0):
			var x_axis: float = speed * cos(deg_to_rad(throw_angle_degrees)) * time
			## Move everything along the x-axis
			global_position = initial_position + direction * x_axis

			projectile_sprite.position.y = - z_axis
		else:
			has_landed = true
			monitoring = false
			monitorable = false
			despawn_timer.start()

# func launch_projectile(
# 	initial_pos: Vector2,
# 	_direction: Vector2,
# 	desired_distance: float,
# 	desired_angle_deg: float,
# 	_damage: float
# ) -> void:
# 	initial_position = initial_pos
# 	direction = _direction.normalized()
# 	damage = _damage

# 	throw_angle_degrees = desired_angle_deg
# 	# Find initial speed based on desired distance (R) and desired angle (theta)
# 	speed = pow(desired_distance * _gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	
# 	global_position = initial_position
# 	time = 0.0

# 	z_axis = 0
# 	is_launch = true

func launch_projectile(
	initial_pos: Vector2,
	_rotation: float,
	desired_distance: float,
	desired_angle_deg: float,
	_damage: float
) -> void:
	initial_position = initial_pos
	direction = Vector2.RIGHT.rotated(_rotation)
	damage = _damage

	throw_angle_degrees = desired_angle_deg
	# Find initial speed based on desired distance (R) and desired angle (theta)
	speed = pow(desired_distance * _gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	
	global_position = initial_position
	time = 0.0

	z_axis = 0
	is_launch = true
	has_landed = false


func _on_despawn_timer_timeout() -> void:
	queue_free()
