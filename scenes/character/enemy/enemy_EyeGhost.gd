@icon("res://scenes/character/enemy/assets/sprites/sprite_enemy_EyeGhost.png")
extends Enemy
class_name EnemyEyeGhost

@export var CIRCLING_DURATION: float = 2.0
@export var CIRCLING_RANGE: float = 150.0
@export var circling_timer: Timer

@export var BACK_AWAY_RANGE: float = 100.0

@export var CHARGE_DISTANCE: float = 400.0
var charge_speed: float = 250.0
var charge_position: Vector2
var charge_direction: Vector2

var range_multiplier: float = 1.0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func apply_mini_boss_effect() -> void:
	super.apply_mini_boss_effect()
	set_health(health * 200)

func set_state(state: ENEMY_STATE) -> void:
	if (_state == state): return

	_state = state
	match _state:
		ENEMY_STATE.CHASING:
			set_collision_mask_value(2, true)
		ENEMY_STATE.CIRCLING:
			circling_timer.start(CIRCLING_DURATION)
		ENEMY_STATE.CHARGING:
			charge()
		
func movement_update(delta) -> void:
	super.movement_update(delta)

	if (_state == ENEMY_STATE.CIRCLING):
		var direction_away_from_player = (global_position - player_ref.global_position).normalized()
		velocity = direction_away_from_player.rotated(PI / 2) * get_movespeed()
		if (is_in_back_away_range()):
			velocity = direction_away_from_player * get_movespeed()
		else:
			velocity = direction_away_from_player.rotated(PI / 2) * get_movespeed()
		return

	if (_state == ENEMY_STATE.CHARGING):
		velocity = charge_direction * charge_speed
		if (is_charge_distance_reached()): set_state(ENEMY_STATE.CHASING)
		return

	if (is_in_circling_range()):
		set_state(ENEMY_STATE.CIRCLING)
		return

func is_in_circling_range() -> bool:
	var distance = player_ref.global_position.distance_to(global_position)
	return distance <= CIRCLING_RANGE

func is_in_back_away_range() -> bool:
	var distance = player_ref.global_position.distance_to(global_position)
	return distance <= BACK_AWAY_RANGE

func is_charge_distance_reached() -> bool:
	var distance = charge_position.distance_to(global_position)
	return distance >= CHARGE_DISTANCE

func charge():
	set_collision_mask_value(2, false)
	charge_position = global_position
	charge_direction = global_position.direction_to(player_ref.global_position)

func _on_circling_timer_timeout() -> void:
	set_state(ENEMY_STATE.CHARGING)
