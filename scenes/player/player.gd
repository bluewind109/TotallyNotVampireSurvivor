extends CharacterBody2D
class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D

# var d: float = 0
# var radius: float = 25
# var speed: float = 2

@onready var loot_range: Area2D = $LootRange

@onready var ghost_timer: Timer = $GhostTimer
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var dash_particles: GPUParticles2D = $DashParticles
@export var dash_cooldown_bar: TextureProgressBar

@export var friction = 0.18
@export var player_hitbox: PlayerHitbox
@export var component_health: Component_Health
@export var component_weapon: Component_Weapon
@export var component_ghost: PackedScene
@export var component_orbit: Component_Orbit

const PLAYER_INPUT = {
	"UP": "up",
	"DOWN": "down",
	"LEFT": "left",
	"RIGHT": "right",
	"ATTACK": "click",
	#"SKILL_1": "skill_1",
	#"SKILL_2": "skill_2",
	"DASH": "dash",
	"RELOAD": "reload",
}

const DASH_MULTIPLIER: float = 15.0

# STAT
var damage: float = 1.0
var base_attack_cooldown: float = 0.2
var knockback_strength: float = 20.0
func set_knockback_strength(val):
	knockback_strength += val

var piercing_strenth: int = 1
func set_piercing_strength(val):
	piercing_strenth = maxi(1, piercing_strenth + val)

var movespeed: float = 150.0
func set_movespeed(val):
	movespeed += val
	SessionData.save_player_stat(UpgradeConfig.UPGRADE_ID.MoveSpeed, movespeed)

var projectile_speed: float = 1000.0

var can_dash: bool = true
var is_dashing: bool = false
var is_dead: bool = false

var nearest_enemy: CharacterBody2D
var nearest_enemy_distance: float = INF

var upgrades: Array[BaseStrategy]

func _ready() -> void:
	SignalManager.on_player_hit.connect(take_damage)
	SignalManager.on_stat_upgrade_selected.connect(add_stat_upgrade)
	can_dash = true
	is_dashing = false
	is_dead = false
	dash_cooldown_bar.hide()
	# component_orbit.set_enabled.call_deferred(true)

	component_weapon.load_weapon_data(WeaponConfig.WEAPON_ID.Shotgun)
	SessionData.save_data({
		"player_stat": {
			UpgradeConfig.UPGRADE_ID.Health: component_health.max_health,
			UpgradeConfig.UPGRADE_ID.MoveSpeed: movespeed,
		},
		"weapon_data": component_weapon.weapon_data
	})

func _physics_process(_delta: float) -> void:
	# find nearest enemy
	if (is_instance_valid(nearest_enemy)):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	var current_velocity: Vector2 = Vector2.ZERO
	current_velocity.x = Input.get_action_strength(PLAYER_INPUT.RIGHT) - Input.get_action_strength(PLAYER_INPUT.LEFT)
	current_velocity.y = Input.get_action_strength(PLAYER_INPUT.DOWN) - Input.get_action_strength(PLAYER_INPUT.UP)
	
	#velocity = Input.get_vector("left", "right", "up", "down") * movespeed # velocity calc
	
	var speed_multiplier = 1.0
	# boost player movespeed for a short time
	if (Input.is_action_just_pressed(PLAYER_INPUT.DASH) and can_dash):
		speed_multiplier = DASH_MULTIPLIER
		dash()

	if (Input.is_action_just_pressed(PLAYER_INPUT.RELOAD)):
		component_weapon.reload()
	
	var target_velocity = current_velocity.normalized() * movespeed * speed_multiplier
	velocity += (target_velocity - velocity) * friction
	
	#move_and_collide(velocity * speed_multiplier * delta) # move & collide with that velocity
	move_and_slide()

func _process(delta: float) -> void:
	if (Input.is_action_pressed(PLAYER_INPUT.ATTACK)):
		component_weapon.attack(self)

	if (not can_dash):
		dash_cooldown_bar.value = (dash_cooldown_timer.time_left / dash_cooldown_timer.wait_time) * 100

func dash():
	if (!can_dash): return
	can_dash = false
	is_dashing = true
	dash_cooldown_timer.start()
	dash_timer.start()
	ghost_timer.start()
	dash_particles.emitting = true
	dash_cooldown_bar.show()

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
	
func add_stat_upgrade(upgrade: BaseStrategy):
	print("add_stat_upgrade " + upgrade.title)
	upgrades.append(upgrade)
	if (upgrade is BasePlayerStatStrategy):
		apply_upgrade(upgrade)
	elif (upgrade is BaseWeaponStrategy):
		component_weapon.apply_upgrade(upgrade)

func apply_upgrade(upgrade: BasePlayerStatStrategy):
	if (upgrade is Strategy_Player_Health):
		component_health.set_max_health(upgrade.get_final_stat())
	if (upgrade is Strategy_Player_MoveSpeed):
		set_movespeed(upgrade.get_final_stat())

func add_buff_upgrade():
	pass

func _on_loot_hitbox_area_entered(_area: Area2D) -> void:
	pass

func _on_loot_range_area_entered(area: Area2D) -> void:
	if (area.has_method("follow")):
		area = area as BasePickup
		area.follow(self)

func _on_component_health_died() -> void:
	die()

func _on_dash_cooldown_timer_timeout() -> void:
	dash_cooldown_bar.hide()
	can_dash = true

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	ghost_timer.stop()
	dash_particles.emitting = false

func _on_ghost_timer_timeout() -> void:
	add_ghost_effect()
