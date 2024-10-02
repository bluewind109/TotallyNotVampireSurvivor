extends BaseWeapon

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile.tscn")

func attack(source: Node2D):
	super.attack(source)
	shoot(source)

func shoot(source: Node2D):
	var projectile = projectile_node.instantiate() as Projectile
	projectile.position = source.position
	projectile.damage = damage
	projectile.speed = speed
	projectile.direction = global_position.direction_to(get_global_mouse_position())
