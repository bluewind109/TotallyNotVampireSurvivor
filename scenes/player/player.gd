extends CharacterBody2D
class_name Player

@onready var loot_range: Area2D = $LootRange

@export var player_hitbox: PlayerHitbox
@export var component_exp: ComponentExp
@export var component_health: ComponentHealth

const PLAYER_INPUT = {
	"UP": "up",
	"DOWN": "down",
	"LEFT": "left",
	"RIGHT": "right",
	"ATTACK": "click",
	#"SKILL_1": "skill_1",
	#"SKILL_2": "skill_2",
	"DASH": "dash",
}

var speed: float = 150.0

var is_dead: bool = false

var nearest_enemy: CharacterBody2D
var nearest_enemy_distance: float = INF

func _ready() -> void:
	SignalManager.on_player_hit.connect(take_damage)
	is_dead = false
	pass

func _physics_process(delta: float) -> void:
	# find nearest enemy
	if (is_instance_valid(nearest_enemy)):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	velocity = Input.get_vector("left", "right", "up", "down") * speed # velocity calc
	move_and_collide(velocity * delta) # move & collide with that velocity

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed(PLAYER_INPUT.ATTACK)):
		
		pass

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
