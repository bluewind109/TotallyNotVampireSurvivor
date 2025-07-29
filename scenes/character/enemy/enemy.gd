extends CharacterBody2D
class_name Enemy

enum ENEMY_STATE {CHASING, SHOOTING, CIRCLING, CHARGING}
var _state = ENEMY_STATE.CHASING

var player_ref: CharacterBody2D:
	get:
		player_ref = GameGlobal.player_ref
		return player_ref

@export var enemy_modifier_container: EnemyModifierContainer

@export var component_health: component_Health
@export var component_barrier: component_Barrier
@export var component_hitbox: component_Hitbox

@export var component_steer: Component_Steer
@export var mass: float = 20.0
		
@export var component_soft_collision: Component_SoftCollision
var soft_collision_strength: float = 200.0

@export var sprite: Sprite2D
@export var hitbox: CollisionShape2D
@export var animation_player: AnimationPlayer

@export var deathParticle: PackedScene

@export var title: String
@export var texture: Texture2D

@export var health: float
func set_health(val: float) -> void:
	component_health.health = val

@export var damage: float
func set_damage(val: float):
	damage = val
func get_damage():
	return damage

@export var speed: float = 50.0
func get_movespeed():
	return speed
func set_movespeed(val: float):
	speed = val

@export var knockback_resistance: float = 5.0

@export var drops: Array[Pickups]

@export var spawn_distance: float = 300.0
@export var despawn_distance: float = 20.0

var direction: Vector2
var _knockback: Vector2
func add_knockback(kb_strength: float, kb_direction: Vector2):
	kb_strength = maxf(0, kb_strength - knockback_resistance)
	_knockback += (kb_direction * kb_strength)

var separation: float

const drop = preload("res://scenes/pickups/pickups.tscn")

var slow_mo_multiplier: float = 1.0
	
var rank: SpawnConfig.ENEMY_RANK = SpawnConfig.ENEMY_RANK.Normal
func set_rank(val: SpawnConfig.ENEMY_RANK):
	rank = val
	var enemy_rank = SpawnConfig.ENEMY_RANK
	match rank:
		enemy_rank.Normal:
			pass
		enemy_rank.Elite:
			apply_elite_effect()
		enemy_rank.Miniboss:
			# show rainbow outline if the enemy is mini-boss / boss
			apply_mini_boss_effect()
		enemy_rank.Boss:
			pass

# var _type: EnemyType
# func set_enemy_type(val: EnemyType) -> void:
# 	_type = val
# 	sprite.texture = _type.texture
# 	set_damage(_type.damage)
# 	set_health(_type.health)
# 	component_health.init(_type.health)
# 	set_movespeed(_type.speed)

var is_dead: bool = false
var is_spawning: bool = false
var is_init: bool = false

func _ready() -> void:
	# setup before spawn animatinon runs
	hitbox.set_deferred("disabled", true)
	sprite.scale = Vector2(0, 0)

func on_dead() -> void:
	if (is_dead): return
	is_dead = true
	drop_item()

	var _particle = deathParticle.instantiate() as GPUParticles2D
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	queue_free()

func init_spawn(
	pos: Vector2,
	_player: CharacterBody2D,
	_rank: SpawnConfig.ENEMY_RANK = SpawnConfig.ENEMY_RANK.Normal,
) -> void:
	position = pos
	set_rank(_rank)
	sprite.texture = texture
	# print("init_spawn")
	component_hitbox.take_damage.connect(take_damage)
	component_health.init(health)
	# component_barrier.init(health) # test

	# call spawn animation
	if (!is_spawning): is_spawning = true
	hitbox.set_deferred("disabled", true)
	play_spawn_animation()
	randomize_movespeed()
	is_init = true

func randomize_movespeed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var _multiplier = rng.randf_range(0.9, 1.1)
	set_movespeed(get_movespeed() * _multiplier)

func play_spawn_animation():
	animation_player.play("SpawnAnimation")

func _physics_process(delta):
	if (is_spawning): return
	check_separation(delta)
	movement_update(delta)

## Apply elite effect and stat
func apply_elite_effect() -> void:
	# base function
	scale = Vector2(1.5, 1.5)

## Apply mini bos effect and stat
func apply_mini_boss_effect() -> void:
	# $Sprite2D.material = load("res://shaders/rainbow_outline.tres")
	# Add colored outline
	sprite.material = ShaderConfig.red_outline
	# Scale enenmy bigger
	scale = Vector2(2.0, 2.0)

func on_slow_mo_toggled(isOn: bool, multiplier: float):
	if (isOn):
		slow_mo_multiplier = multiplier
	else:
		slow_mo_multiplier = 1.0

func set_state(state: ENEMY_STATE) -> void:
	if (_state == state): return

	_state = state
	match _state:
		ENEMY_STATE.CHASING:
			pass

## Despawn enemies if too far from player AND not elite
func check_separation(_delta):
	return
	if (!is_init): return
	separation = (player_ref.position - position).length()
	if separation >= 500 and rank == SpawnConfig.ENEMY_RANK.Normal:
		queue_free()
	
	if separation < player_ref.nearest_enemy_distance:
		player_ref.nearest_enemy = self

func movement_update(delta):
	if (!is_init): return
	_knockback = _knockback.move_toward(Vector2.ZERO, 1) # decay over time
	velocity += _knockback
	if (component_soft_collision.is_colliding()):	
		velocity += component_soft_collision.get_push_vector() * delta * soft_collision_strength
	
	velocity = velocity
	move_and_slide()

	if (_state == ENEMY_STATE.CHASING):
		seek_player()
		return
	
	# var collider = move_and_collide(velocity * delta)
	# knockback_update(collider)
func seek_player():
	# move toward player
	# velocity = basic_chase(global_position, player_ref.global_position)

	# var vec_to_player = player.global_position - global_position
	# vec_to_player = vec_to_player.normalized()
	# global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	# global_rotation = atan2(scaled_desired_velocity.y, scaled_desired_velocity.x)
	velocity = component_steer.steer(
		velocity,
		global_position,
		player_ref.global_position,
		get_movespeed() * GameGlobal.slow_mo_multiplier,
		mass
	)
	# sprite.rotation = velocity.angle() # look towards player

func basic_chase(
	global_pos: Vector2,
	target_pos: Vector2,
) -> Vector2:
	var desired_velocity = target_pos - global_pos
	var normalized_dv = desired_velocity.normalized()
	return normalized_dv * get_movespeed()

func knockback_update(collider):
	if collider:
		# apply knockback to bodies colliding with enemy
		collider.get_collider()._knockback = (collider.get_collider().global_position -
		global_position).normalized() * 50

func shoot_prediction():
	pass

## Show damage popup on enemy hit
func damage_popup(amount: float, is_crit: bool = false):
	var spawn_position = global_position + Vector2(0, -5)
	SignalManager.ui_show_damage.emit(spawn_position, amount, is_crit)

func take_damage(amount: float, kb_strength: float, kb_direction: Vector2, is_crit: bool):
	if (is_spawning): return
	
	damage_popup(amount, is_crit)
	add_knockback(kb_strength, kb_direction)

	# if barrier is still active, absorb damage instead
	if (component_barrier.is_active):
		component_barrier.absorb_damage(amount)
		return

	component_health.take_damage(amount)

	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(0.799, 0.146, 0.044, 1), 0.2)
	tween.chain().tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.2)
	# Fix warning "Target object freed before 
	# starting, aborting Tweener."
	tween.bind_node(self)

func drop_item():
	if (drops.size() == 0): return
	
	var item: Pickups = drops.pick_random()
	var item_to_drop = drop.instantiate() as BasePickup
	
	item_to_drop.init_item(item, position, player_ref)
	SignalManager.on_enemy_dead.emit(item_to_drop)

func on_spawn_anim_finished():
	is_spawning = false
	hitbox.set_deferred("disabled", false)

func add_modifier() -> void:
	return
