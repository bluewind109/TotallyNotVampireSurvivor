extends BaseWeapon

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile.tscn")

func attack(source: Player):
	super(source)
	
	if (!is_ready): return
	is_ready = false
	basic_attack_timer.start(cooldown)
	shoot(source)

func shoot(source: Player):
	var projectile = projectile_node.instantiate() as Projectile

	## Apply upgrade before spawn bullet
	# print("shoot: ", source.upgrades.size())
	for strategy in source.upgrades:
		projectile = strategy.apply_upgrade(projectile)

	projectile.init_projectile(
		source.position,
		global_position.direction_to(get_global_mouse_position()),
		projectile.speed,
		projectile.damage
	)
	get_tree().current_scene.add_child(projectile)
