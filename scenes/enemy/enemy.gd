extends CharacterBody2D
class_name Enemy

enum ENEMY_STATE {CHASING, SHOOTING}
var _state = ENEMY_STATE.CHASING

@export var player_ref: CharacterBody2D

@export var deathParticle: PackedScene

@export var title: String
@export var texture: Texture2D

@export var health: float
	# set(value):
	# 	health = value
	# 	if (health <= 0 and !is_dead):
	# 		is_dead = true
	# 		SignalManager.on_enemy_dead.emit()
	# 		drop_item()
	# 		queue_free()
func set_health(val: float) -> void:
	health = val
	if (health <= 0 and !is_dead):
		is_dead = true
		# SignalManager.on_enemy_dead.emit()
		drop_item()
		on_dead()

@export var damage: float
@export var speed: float = 50.0
@export var drops: Array[Pickups]
@export var despawn_distance: float = 20.0

var damage_popup_node = preload("res://scenes/damage/damage.tscn")
var direction: Vector2
var _knockback: Vector2
func add_knockback(val: Vector2):
	_knockback += val

var separation: float

var drop = preload("res://scenes/pickups/pickups.tscn")
	
var _elite: bool = false
	# set(value):
	# 	_elite = value
	# 	# show rainbow outline if the enemy is elite
	# 	if (value):
	# 		$Sprite2D.material = load("res://shaders/rainbow_outline.tres")
	# 		scale = Vector2(1.5, 1.5)
func set_elite(val: bool) -> void:
	_elite = val
	# show rainbow outline if the enemy is elite
	if (val):
		$Sprite2D.material = load("res://shaders/rainbow_outline.tres")
		scale = Vector2(1.5, 1.5)

var _type: EnemyType
func set_enemy_type(val: EnemyType) -> void:
	_type = val
	$Sprite2D.texture = _type.texture
	damage = _type.damage
	set_health(_type.health)
	speed = _type.speed
	pass

var is_dead: bool = false

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	# on_dead()

func on_dead() -> void:
	var _particle = deathParticle.instantiate() as GPUParticles2D
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	queue_free()

func init_spawn(pos: Vector2, player: CharacterBody2D, elite: bool) -> void:
	position = pos
	player_ref = player
	set_elite(elite)

func _physics_process(delta):
	check_separation(delta)
	movement_update(delta)

func set_state(state: ENEMY_STATE) -> void:
	if (_state == state): return

	_state = state
	match _state:
		ENEMY_STATE.CHASING:
			pass
		ENEMY_STATE.SHOOTING:
			pass

func check_separation(_delta):
	# despawn enemies if too far from player AND not elite
	separation = (player_ref.position - position).length()
	if separation >= 500 and not _elite:
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

# show damage popup on enemy hit
func damage_popup(amount):
	var popup = damage_popup_node.instantiate() as DamagePopup
	popup.text = str(amount)
	popup.position = position + Vector2(-50, -25)
	get_tree().current_scene.add_child(popup)

func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(0.799, 0.146, 0.044), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.2)
	# Fix warning "Target object freed before 
	# starting, aborting Tweener."
	tween.bind_node(self) 
	
	damage_popup(amount)
	var new_health = health - amount
	set_health(new_health)
	# health -= amount

func drop_item():
	if (drops.size() == 0): return
	
	var item: Pickups = drops.pick_random()
	var item_to_drop = drop.instantiate() as BasePickup
	
	item_to_drop.init_item(item, position, player_ref)
	SignalManager.on_enemy_dead.emit(item_to_drop)
	# get_tree().current_scene.call_deferred("add_child", item_to_drop)
