extends BaseProjectileStrategy
class_name ProjectileDamageStrategy

@export var projectile_damage: float = 1.0

func apply_upgrade(projectile: Projectile):
	projectile.damage += projectile_damage
	return projectile