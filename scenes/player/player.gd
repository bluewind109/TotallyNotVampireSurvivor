extends CharacterBody2D
class_name Player

@onready var loot_range: Area2D = $LootRange

@export var player_hitbox: PlayerHitbox
@export var component_exp: ComponentExp
@export var component_health: ComponentHealth

var speed: float = 150.0

var is_dead: bool = false

var nearest_enemy: CharacterBody2D
var nearest_enemy_distance: float = INF

func _ready() -> void:
	SignalManager.on_player_hit.connect(take_damage)
	is_dead = false
	pass

func _physics_process(delta):
	if (is_instance_valid(nearest_enemy)):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	velocity = Input.get_vector("left", "right", "up", "down") * speed # velocity calc
	move_and_collide(velocity * delta) # move & collide with that velocity

func take_damage(amount: float):
	if (is_dead): return
	component_health.take_damage(amount)
	
func die():
	if (is_dead): return
	# block input
	# go to gameover
	pass

func _on_loot_hitbox_area_entered(area: Area2D) -> void:
	pass

func _on_loot_range_area_entered(area: Area2D) -> void:
	if (area.has_method("follow")):
		area.follow(self)

func _on_component_health_died() -> void:
	die()
