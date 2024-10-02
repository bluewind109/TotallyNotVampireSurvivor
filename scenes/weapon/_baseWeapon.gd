extends Node2D
class_name BaseWeapon

@onready var pivot: Marker2D = $Pivot

# properties for projectile
@export var damage: float
@export var cooldown: float
@export var speed: float

var weapon_type: String
var weapon_range_type: String

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pivot.look_at(get_global_mouse_position())
	# make the weapon floating vertical slightly
	pivot.position.y = sin(Time.get_ticks_msec() * delta * 0.2) * 1.5
	pass

func attack(source: Node2D):
	pass
