extends GunData
class_name ShotgunData

@export_range(0, 360) var arc_spread: float = 0
func get_arc_spread(is_base: bool = false):
	if (is_base):
		return arc_spread
	else:
		return arc_spread + arc_spread * arc_spread_multiplier

var arc_spread_multiplier: float = 0
func add_arc_spread_multiplier(val):
	arc_spread_multiplier += val

func attack(_player: Player, _direction: Vector2):
	current_ammo -= 1
	# TODO use weapon's projectile speed var
	for i in 3:
		var projectile = projectile_node.instantiate() as Projectile
		var arc_rad = deg_to_rad(get_arc_spread())
		var increment = arc_rad / (3 - 1)
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
	super.full_reload()

func reload():
	current_ammo = mini(current_ammo + 1, max_ammo)
