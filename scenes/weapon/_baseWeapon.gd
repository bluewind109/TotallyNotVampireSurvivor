extends Node2D
class_name BaseWeapon

@export var title: String
@export var texture: Texture2D

@onready var pivot: Marker2D = $Pivot
@onready var basic_attack_timer: Timer = $BasicAttackTimer

# properties for projectile
@export var damage: float
@export var cooldown: float
@export var speed: float

var weapon_type: String
var weapon_range_type: String
var is_ready: bool = true

@export var upgrades: Array[ProjectileUpgrade]
var level = 1

func _ready() -> void:
	is_ready = true
	pass
	
func _physics_process(delta: float) -> void:
	pivot.look_at(get_global_mouse_position())
	# make the weapon floating vertical slightly
	pivot.position.y = sin(Time.get_ticks_msec() * delta * 0.2) * 1.5
	pass

func attack(source: Node2D):
	pass
	
func is_upgradable() -> bool:
	if (level <=  upgrades.size()):
		return true
	return false

func upgrade_item():
	if (!is_upgradable()): return
	
	var upgrade = upgrades[level - 1]
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	speed += upgrade.speed
	level += 1
	
	if (cooldown < 0.15): cooldown = 0.15

func _on_basic_attack_timer_timeout() -> void:
	is_ready = true
	pass # Replace with function body.
