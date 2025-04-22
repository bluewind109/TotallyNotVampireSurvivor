extends BaseProjectileStrategy
class_name ProjectileSpeedStrategy

@export var projectile_speed: float = 50.0

func get_desc() -> String:
	title = "Speed"
	description = "Increase projectile speed by [color=green]{0}[/color]"
	description = description.format([projectile_speed])
	return description

func apply_upgrade(projectile: Projectile):
	projectile.speed += projectile_speed
	return projectile