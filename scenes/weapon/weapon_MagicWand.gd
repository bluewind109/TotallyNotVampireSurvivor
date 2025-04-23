extends BaseWeapon

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile.tscn")

func attack(player: Player):
	super(player)
	
	if (!is_ready): return
	is_ready = false
	basic_attack_timer.start(player.base_attack_cooldown)
	shoot(player)

func shoot(player: Player):
	var projectile = projectile_node.instantiate() as Projectile

	## Apply upgrade before spawn bullet
	# print("shoot: ", player.upgrades.size())
	# for strategy in player.upgrades:
	# 	projectile = strategy.apply_upgrade(projectile)

	projectile.init_projectile(
		player.position,
		global_position.direction_to(get_global_mouse_position()),
		player.projectile_speed,
		player.damage
	)
	get_tree().current_scene.add_child(projectile)
