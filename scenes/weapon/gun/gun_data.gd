extends WeaponData
class_name GunData

@export var gun_type: WeaponConfig.GUN_TYPE
@export var max_ammo: int = 1
func set_max_ammo(val):
	# print_debug("set_max_ammo: ", val)
	max_ammo = maxi(1, val)
	# update UI
	SignalManager.ui_update_ammo_count.emit(current_ammo, max_ammo)
func get_max_ammo(is_base: bool = false):
	if (is_base):
		return max_ammo
	else:
		return max_ammo + max_ammo * max_ammo_multiplier

var max_ammo_multiplier: float = 0
func add_max_ammo_multiplier(val):
	max_ammo_multiplier += val

@export var projectile_speed: float = 1000.0
func get_projectile_speed(is_base: bool = false):
	if (is_base):
		return projectile_speed
	else:
		return projectile_speed + projectile_speed * projectile_multiplier

var projectile_multiplier: float = 0.0
func add_projecctile_multiplier(val):
	projectile_multiplier += val

@export var projectile_node: PackedScene
@export var reload_time: float
func get_reload_time(is_base: bool = false):
	if (is_base):
		return reload_time
	else:
		return maxf(0.1, reload_time - reload_time * reload_time_multiplier)

var reload_time_multiplier: float = 0
func add_reload_time_multiplier(val):
	reload_time_multiplier += val

@export var pierce_strength: int = 1
func set_pierce_strenth(val):
	pierce_strength = val

var reload_timer: Timer

@export_range(0, 360) var arc_accuracy: float = 0
func get_arc_accuracy(is_base: bool = false):
	if (is_base):
		return arc_accuracy
	else:
		return arc_accuracy + arc_accuracy * arc_accuracy_multiplier

var arc_accuracy_multiplier: float = 0
func add_arc_accuracy_multiplier(val):
	arc_accuracy_multiplier += val

var current_ammo: int:
	set(val):
		current_ammo = maxi(0, val)
		# update UI
		SignalManager.ui_update_ammo_count.emit(current_ammo, max_ammo)

func init_data() -> void:
	call_deferred("set_max_ammo", max_ammo)
	current_ammo = get_max_ammo()

func attack(_player: Player, _direction: Vector2):
	current_ammo -= 1
	var projectile = projectile_node.instantiate() as Projectile
	var arc_rad = deg_to_rad(get_arc_accuracy())
	var increment = arc_rad / (3 - 1)
	var i = randi_range(0, 10)
	var _rotation = _direction.angle() + increment * i - arc_rad / 2

	projectile.init_projectile(
	_player.position,
	_rotation,
	get_projectile_speed(),
	get_damage(),
	get_knockback_strength(),
	pierce_strength)
	_player.get_tree().current_scene.call_deferred("add_child", projectile)

func full_reload():
	current_ammo = get_max_ammo()

func reload():
	current_ammo = get_max_ammo()

func can_reload():
	return current_ammo < get_max_ammo()

func get_all_stat() -> void:
	super.get_all_stat()
	var get_gun_stat_dict = {
		"MaxAmmo": get_max_ammo(),
		"ProjectileSpeed": get_projectile_speed(),
		"ReloadTime": get_reload_time(),
		"PierceStrength": pierce_strength,
		"Accuracy": get_arc_accuracy()
	}
	stat_dict = stat_dict.merged(get_gun_stat_dict)