extends CharacterBody2D
class_name Enemy

enum ENEMY_STATE {CHASING, SHOOTING}
var _state = ENEMY_STATE.CHASING

@export var player_ref: CharacterBody2D
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
@export var speed: float = 50.0
@export var knockback_resistance: float = 5.0

@export var drops: Array[Pickups]
@export var despawn_distance: float = 20.0

@export var mini_boss_outline: Resource

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
	damage = _type.damage
	set_health(_type.health)
	speed = _type.speed

var is_dead: bool = false
var is_spawning: bool = false

func _ready() -> void:
	# setup before spawn animatinon runs
	hitbox.set_deferred("disabled", true)
	sprite.scale = Vector2 (0, 0)

	# await get_tree().create_timer(1).timeout
	# on_dead()

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
	player_ref = player
	set_rank(_rank)
	sprite.texture = texture

	# call spawn animation
	if (!is_spawning): is_spawning = true
	hitbox.set_deferred("disabled", true)
	play_spawn_animation()

func randomize_movespeed():
	pass

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
	sprite.material = mini_boss_outline
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
	separation = (player_ref.position - position).length()
	if separation >= 500 and rank == SpawnConfig.ENEMY_RANK.Normal:
		queue_free()
	
	if separation < player_ref.nearest_enemy_distance:
		player_ref.nearest_enemy = self

func movement_update(delta):
	match _state:
		ENEMY_STATE.CHASING:
			# move toward player
			velocity = (player_ref.position - position).normalized() * speed
		_:
			pass
	
	_knockback = _knockback.move_toward(Vector2.ZERO, 1) # decay over time
	velocity += _knockback
	var collider = move_and_collide(velocity * delta)
	knockback_update(collider)

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
