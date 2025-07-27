@icon("res://scenes/character/enemy/assets/sprites/sprite_enemy_Eye.png")
extends Enemy
class_name EnemyEye

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile_Enemy.tscn")
@export var projectile_speed: float = 50.0
@export var projectile_damage: float = 5.0

@onready var shoot_timer: Timer = $ShootTimer

const SHOOT_RANGE: float = 250.0 ## shoot when in X range
const SHOOT_DURATION: float = 5.0 ## shoot every X seconds

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func apply_mini_boss_effect() -> void:
	super.apply_mini_boss_effect()
	set_health(health * 150)

func set_state(state: ENEMY_STATE) -> void:
	if (_state == state): return

	_state = state
	match _state:
		ENEMY_STATE.CHASING:
			pass
		ENEMY_STATE.SHOOTING:
			shoot()

func movement_update(delta) -> void:
	super.movement_update(delta)

	if (_state == ENEMY_STATE.SHOOTING):
		velocity = Vector2.ZERO

	if (is_in_shooting_range()):
		set_state(ENEMY_STATE.SHOOTING)
	
func is_in_shooting_range() -> bool:
	var distance = player_ref.global_position.distance_to(global_position)
	return distance <= SHOOT_RANGE

func shoot() -> void:
	if (!shoot_timer.is_stopped()): return
	# print("shoot")
	shoot_timer.start(SHOOT_DURATION)

	# Spawn a bullet and let it fly toward player
	var projectile = projectile_node.instantiate() as ProjectileEnemy
	projectile.init_projectile(
		position,
		global_position.direction_to(player_ref.global_position),
		projectile_speed,
		projectile_damage
	)
	SignalManager.on_projectile_spawn.emit(projectile, false)
	# get_tree().current_scene.add_child(projectile)	

func _on_shoot_timer_timeout() -> void:
	if (!is_in_shooting_range()):
		# print("shoot_timer_done")
		set_state(ENEMY_STATE.CHASING)
		return
	
	shoot()
