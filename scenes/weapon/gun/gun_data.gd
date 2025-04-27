extends WeaponData
class_name GunData

@export var gun_type: WeaponConfig.GUN_TYPE
@export var max_ammo: int = 1
@export var projectile_speed: float = 1000.0
@export var projectile_node: PackedScene
@export var reload_time: float

var current_ammo: int:
	set(val):
		current_ammo = maxi(0, val)
		# update UI
		SignalManager.ui_update_ammo_count.emit(current_ammo, max_ammo)

func set_max_ammo(val):
	# print_debug("set_max_ammo: ", val)
	max_ammo = maxi(1, val)
	# update UI
	SignalManager.ui_update_ammo_count.emit(current_ammo, max_ammo)

func init_data() -> void:
	call_deferred("set_max_ammo", max_ammo)
	current_ammo = max_ammo