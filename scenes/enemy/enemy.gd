extends CharacterBody2D
class_name Enemy

enum ENEMY_STATE {CHASING, SHOOTING}
var _state = ENEMY_STATE.CHASING

@export var player_ref: CharacterBody2D
var damage_popup_node = preload("res://scenes/damage/damage.tscn")
var direction: Vector2
var speed: float
var damage: float
var _knockback: Vector2
func add_knockback(val: Vector2):
	_knockback += val

var separation: float

var drop = preload("res://scenes/pickups/pickups.tscn")

var health: float:
	set(value):
		health = value
		if (health <= 0 and !is_dead):
			is_dead = true
			SignalManager.on_enemy_dead.emit()
			drop_item()
			queue_free()
	
var _elite: bool = false:
	set(value):
		_elite = value
		# show rainbow outline if the enemy is elite
		if (value):
			$Sprite2D.material = load("res://shaders/rainbow_outline.tres")
			scale = Vector2(1.5, 1.5)

var _type: EnemyType
func set_enemy_type(val: EnemyType) -> void:
	_type = val
	$Sprite2D.texture = _type.texture
	damage = _type.damage
	health = _type.health
	speed = _type.speed
	pass

var is_dead: bool = false

func init_spawn(pos: Vector2, player: CharacterBody2D, elite: bool) -> void:
	position = pos
	player_ref = player
	_elite = elite

func _physics_process(delta):
	check_separation(delta)
	movement_update(delta)

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
			match _type.title:
				"Eye":
					# move toward player but keep some distance
					var distance = player_ref.global_position.distance_to(global_position)
					if (distance > 250.0):
						velocity = (player_ref.position - position).normalized() * speed
					else:
						velocity = Vector2.ZERO
				_:
					# move toward player
					velocity = (player_ref.position - position).normalized() * speed
		_:
			pass;
	
	_knockback = _knockback.move_toward(Vector2.ZERO, 1) # decay over time
	velocity += _knockback
	var collider = move_and_collide(velocity * delta)
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
	health -= amount

func drop_item():
	if (_type.drops.size() == 0): return
	
	var item = _type.drops.pick_random()
	var item_to_drop = drop.instantiate() as BasePickup
	
	item_to_drop.init_item(item, position, player_ref)
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
