extends CharacterBody2D
class_name Player

@onready var loot_range: Area2D = $LootRange
@onready var exp_bar: ProgressBar = $"UI/EXP/EXP Bar"
@onready var label_level: Label = $UI/LabelLevel

var speed: float = 150.0
var health: float = 100.0:
	set(value):
		health = value
		%Health.value = value

var nearest_enemy: CharacterBody2D
var nearest_enemy_distance: float = INF

# EXP formula: curent level * base exp * multiplier 
var base_exp_require: float = 100.0
var exp_require_multiplier: float  = 1.25
var exp_require: float = 0

var current_exp: float = 0.0:
	set(value):
		current_exp = value
		exp_bar.value = (current_exp / exp_require) * 100

var level: int = 1:
	set(value):
		level = value
		label_level.text = "Level %s" % str(level) 

func _ready() -> void:
	level = 1
	exp_require = level * base_exp_require * exp_require_multiplier

func _physics_process(delta):
	if (is_instance_valid(nearest_enemy)):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	velocity = Input.get_vector("left", "right", "up", "down") * speed # velocity calc
	move_and_collide(velocity * delta) # move & collide with that velocity

func take_damage(amount):
	health -= amount
	print("take_damage: ", amount)

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)


func _on_loot_hitbox_area_entered(area: Area2D) -> void:
	#print("_on_loot_hitbox_area_entered: ", area)
	# increase player's EXP
	if (area.is_in_group("Item") and area.is_in_group("Food")):
		current_exp += 5
		area.consume()
		print("take food: ", current_exp)


func _on_loot_range_area_entered(area: Area2D) -> void:
	if (area.item_type == "burger"):
		print("_on_loot_range_area_entered: ", area)
		area.is_in_loot_range = true
