extends CharacterBody2D
class_name Enemy

enum ENEMY_STATE {CHASING, SHOOTING, CIRCLING, CHARGING}
var _state = ENEMY_STATE.CHASING

var player_ref: CharacterBody2D:
	get:
		player_ref = GameGlobal.player_ref
		return player_ref

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
	health = val
	if (health <= 0 and !is_dead):
		is_dead = true
		# SignalManager.on_enemy_dead.emit()
		drop_item()
		on_dead()

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
func add_knockback(kb_direction: Vector2, kb_strength: float):
	kb_strength = maxf(0, kb_strength - knockback_resistance)
	_knockback += (kb_direction * kb_strength)

var separation: float

var drop = preload("res://scenes/pickups/pickups.tscn")
	
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

var _type: EnemyType
func set_enemy_type(val: EnemyType) -> void:
	_type = val
	sprite.texture = _type.texture
	set_damage(_type.damage)
	set_health(_type.health)
	set_movespeed(_type.speed)

var is_dead: bool = false
var is_spawning: bool = false
var is_init: bool = false

func _ready() -> void:
	# setup before spawn animatinon runs
	hitbox.set_deferred("disabled", true)
	sprite.scale = Vector2(0, 0)

func on_dead() -> void:
	var _particle = deathParticle.instantiate() as GPUParticles2D
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	queue_free()

func init_spawn(
	pos: Vector2,
	player: CharacterBody2D,
	_rank: SpawnConfig.ENEMY_RANK = SpawnConfig.ENEMY_RANK.Normal,
) -> void:
	position = pos
	set_rank(_rank)
	sprite.texture = texture

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

func set_state(state: ENEMY_STATE) -> void:
	if (_state == state): return

	_state = state
	match _state:
		ENEMY_STATE.CHASING:
			pass
		ENEMY_STATE.SHOOTING:
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

var cumulated_delta: float = 0.0
func movement_update(delta):
	if (!is_init): return
	# if (_state == )

	# cumulated_delta += delta
	match _state:
		ENEMY_STATE.CHASING:
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
				get_movespeed(),
				mass
			)
			# sprite.rotation = velocity.angle() # look towards player
		_:
			pass
	
	_knockback = _knockback.move_toward(Vector2.ZERO, 1) # decay over time
	velocity += _knockback
	if (component_soft_collision.is_colliding()):	
		velocity += component_soft_collision.get_push_vector() * delta * soft_collision_strength
	move_and_slide()
	# var collider = move_and_collide(velocity * delta)
	# knockback_update(collider)

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



## Show damage popup on enemy hit
func damage_popup(amount: float, is_crit: bool = false):
	var spawn_position = global_position + Vector2(0, -5)
	SignalManager.ui_show_damage.emit(spawn_position, amount, is_crit)

func take_damage(amount: float, is_crit: bool = false):
	if (is_spawning): return
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(0.799, 0.146, 0.044), 0.2)
	tween.chain().tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)
	# Fix warning "Target object freed before 
	# starting, aborting Tweener."
	tween.bind_node(self)
	
	damage_popup(amount, is_crit)
	var new_health = health - amount
	set_health(new_health)
	# health -= amount

## Drop item on enemy dead
func drop_item():
	if (drops.size() == 0): return
	
	var item: Pickups = drops.pick_random()
	var item_to_drop = drop.instantiate() as BasePickup
	
	item_to_drop.init_item(item, position, player_ref)
	SignalManager.on_enemy_dead.emit(item_to_drop)
	# get_tree().current_scene.call_deferred("add_child", item_to_drop)

func on_spawn_anim_finished():
	is_spawning = false
	hitbox.set_deferred("disabled", false)
