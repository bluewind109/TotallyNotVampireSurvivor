extends BaseWeapon

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile.tscn")

func attack(source: Node2D):
	super(source)
	
	if (!is_ready): return
	is_ready = false
	basic_attack_timer.start(cooldown)
	shoot(source)

func shoot(source: Node2D):
	var projectile = projectile_node.instantiate() as Projectile
	projectile.init_projectile(
		source.position,
		global_position.direction_to(get_global_mouse_position()),
		speed,
		damage
	)
	get_tree().current_scene.add_child(projectile)
