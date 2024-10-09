extends CharacterBody2D
class_name Enemy

@export var player_ref: CharacterBody2D
var damage_popup_node = preload("res://scenes/damage/damage.tscn")
var direction: Vector2
var speed: float
var damage: float
var knockback: Vector2
var separation: float

var drop = preload("res://scenes/pickups/pickups.tscn")

var health: float:
	set(value):
		health = value
		if (health <= 0):
			drop_item()
			queue_free()
	
var elite: bool = false:
	set(value):
		elite = value
		# show rainbow outline if the enemy is elite
		if (value):
			$Sprite2D.material = load("res://shaders/rainbow_outline.tres")
			scale = Vector2(1.5, 1.5)

var type: EnemyType:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage
		health = value.health
		speed = value.speed

func _physics_process(delta):
	check_separation(delta)		
	knockback_update(delta)

func check_separation(_delta):
	# despawn enemies if too far from player AND not elite
	separation = (player_ref.position - position).length()
	if separation >= 500 and not elite:
		queue_free()
	
	if separation < player_ref.nearest_enemy_distance:
		player_ref.nearest_enemy = self

func knockback_update(delta):
	# move toward player
	velocity = (player_ref.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1) # decay over time
	velocity += knockback
	
	var collider = move_and_collide(velocity * delta)
	if collider:
		# apply knockback to bodies colliding with enemy
		collider.get_collider().knockback = (collider.get_collider().global_position - 
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
	if (type.drops.size() == 0): return
	
	var item = type.drops.pick_random()
	var item_to_drop: BasePickup = drop.instantiate() as BasePickup
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_ref = player_ref
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
