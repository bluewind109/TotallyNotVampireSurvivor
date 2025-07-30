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

func attack(_position: Vector2, _direction: Vector2):
	current_ammo -= 1
	var pellet_amount: int = 3
	for i in pellet_amount:
		var projectile = projectile_node.instantiate() as Projectile
		var arc_rad = deg_to_rad(get_arc_spread())
		var increment = arc_rad / (pellet_amount - 1)
		var _rotation = _direction.angle() + increment * i - arc_rad / 2

		projectile.init_projectile(
			_position,
			_rotation,
			get_projectile_speed(),
			get_damage(),
			get_knockback_strength(),
			pierce_strength,
			get_crit_chance(),
			get_crit_dmg(),
		)
		SignalManager.on_projectile_spawn.emit(projectile, false)

func full_reload():
	super.full_reload()

func reload():
	current_ammo = mini(current_ammo + 1, get_max_ammo())
