extends CharacterBody2D
class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var loot_range: Area2D = $LootRange
@onready var weapon_magic_wand: Node2D = $WeaponContainer/weapon_MagicWand

@onready var ghost_timer: Timer = $GhostTimer
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var dash_particles: GPUParticles2D = $DashParticles

@export var friction = 0.18
@export var player_hitbox: PlayerHitbox
@export var component_exp: ComponentExp
@export var component_health: ComponentHealth
@export var component_ghost: PackedScene

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

const DASH_MULTIPLIER: float = 15.0
var speed: float = 150.0

var can_dash: bool = true
var is_dashing: bool = false
var is_dead: bool = false

var nearest_enemy: CharacterBody2D
var nearest_enemy_distance: float = INF

func _ready() -> void:
	SignalManager.on_player_hit.connect(take_damage)
	can_dash = true
	is_dashing = false
	is_dead = false

func _physics_process(delta: float) -> void:
	# find nearest enemy
	if (is_instance_valid(nearest_enemy)):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	var current_velocity: Vector2 = Vector2.ZERO
	current_velocity.x = Input.get_action_strength(PLAYER_INPUT.RIGHT) - Input.get_action_strength(PLAYER_INPUT.LEFT)
	current_velocity.y = Input.get_action_strength(PLAYER_INPUT.DOWN) - Input.get_action_strength(PLAYER_INPUT.UP)
	
	#velocity = Input.get_vector("left", "right", "up", "down") * speed # velocity calc
	
	var speed_multiplier = 1.0
	# boost player speed for a short time
	if (Input.is_action_just_pressed(PLAYER_INPUT.DASH) and can_dash):
		speed_multiplier = DASH_MULTIPLIER
		dash()
	
	var target_velocity = current_velocity.normalized() * speed * speed_multiplier
	velocity += (target_velocity - velocity) * friction
	
	#move_and_collide(velocity * speed_multiplier * delta) # move & collide with that velocity
	move_and_slide()

func _process(delta: float) -> void:
	if (Input.is_action_pressed(PLAYER_INPUT.ATTACK)):
		weapon_magic_wand.attack(self)
		pass

func dash():
	if (!can_dash): return
	can_dash = false
	is_dashing = true
	dash_cooldown_timer.start()
	dash_timer.start()
	ghost_timer.start()
	dash_particles.emitting = true

func add_ghost_effect():
	#print_debug("add_ghost_effect")
	var ghost_effect = component_ghost.instantiate() as Sprite2D
	ghost_effect.set_property(
		position, 
		sprite_2d.scale
	)
	#ghost_effect.set_frames(player_sprite.sprite_frames)
	ghost_effect.texture = sprite_2d.texture
	#ghost_effect.set_anim(PLAYER_ANIM.RUN)
	get_tree().current_scene.add_child(ghost_effect)

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

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	ghost_timer.stop()
	dash_particles.emitting = false

func _on_ghost_timer_timeout() -> void:
	add_ghost_effect()
