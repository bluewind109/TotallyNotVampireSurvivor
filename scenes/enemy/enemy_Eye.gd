extends Enemy
class_name EnemyEye

@onready var shoot_timer: Timer = $ShootTimer

const SHOOT_RANGE: float = 250.0 ## shoot when in X range
const SHOOT_DURATION: float = 5.0 ## shoot every X seconds

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func set_state(state: ENEMY_STATE) -> void:
	if (_state == state): return

	_state = state
	match _state:
		ENEMY_STATE.CHASING:
			pass
		ENEMY_STATE.SHOOTING:
			shoot()

func movement_update(delta) -> void:
	match _state:
		ENEMY_STATE.CHASING:
			# move toward player but keep some distance
			if (!is_in_shooting_range()):
				velocity = (player_ref.position - position).normalized() * speed
			else:
				set_state(ENEMY_STATE.SHOOTING)
		ENEMY_STATE.SHOOTING:
			velocity = Vector2.ZERO
		_:
			pass
	
	_knockback = _knockback.move_toward(Vector2.ZERO, 1) # decay over time
	velocity += _knockback
	var collider = move_and_collide(velocity * delta)
	knockback_update(collider)

func is_in_shooting_range() -> bool:
	var distance = player_ref.global_position.distance_to(global_position)
	return distance <= SHOOT_RANGE

func shoot() -> void:
	if (shoot_timer.is_stopped()): return
	shoot_timer.start()

	# TODO Spawn a bullet and let it fly toward player

func _on_shoot_timer_timeout() -> void:
	if (!is_in_shooting_range()):
		set_state(ENEMY_STATE.CHASING)
		return
	
	shoot()
