extends BaseProjectileStrategy
class_name ProjectileSpeedStrategy

@export var projectile_speed: float = 50.0

func apply_upgrade(projectile: Projectile):
	projectile.speed += projectile_speed
	return projectile