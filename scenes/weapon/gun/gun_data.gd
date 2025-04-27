extends WeaponData
class_name GunData

@export var gun_type: WeaponConfig.GUN_TYPE
@export var max_ammo: int = 1
@export var projectile_speed: float = 1000.0
@export var projectile_node: PackedScene
@export var reload_time: float

var reload_timer: Timer

@export_range(0, 360) var arc_accuracy: float = 0

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

func attack(_player: Player, _direction: Vector2):
	current_ammo -= 1
	# TODO use weapon's projectile speed var
	var projectile = projectile_node.instantiate() as Projectile
	var arc_rad = deg_to_rad(arc_accuracy)
	var increment = arc_rad / (3 - 1)
	var i = randi_range(0, 10)
	var _rotation = _direction.angle() + increment * i - arc_rad / 2

	projectile.init_projectile(
	_player.position,
	_rotation,
	projectile_speed,
	damage,
	_player.knockback_strength,
	_player.piercing_strenth)
	_player.get_tree().current_scene.call_deferred("add_child", projectile)

func full_reload():
	current_ammo = max_ammo

func reload():
	current_ammo = max_ammo

func can_reload():
	return current_ammo < max_ammo
