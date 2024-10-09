extends Node2D
class_name BaseWeapon

@onready var pivot: Marker2D = $Pivot
@onready var basic_attack_timer: Timer = $BasicAttackTimer

# properties for projectile
@export var damage: float
@export var cooldown: float
@export var speed: float

var weapon_type: String
var weapon_range_type: String
var is_ready: bool = true

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

func _on_basic_attack_timer_timeout() -> void:
	is_ready = true
	pass # Replace with function body.
