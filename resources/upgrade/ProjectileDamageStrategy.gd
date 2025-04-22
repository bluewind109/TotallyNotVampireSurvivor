extends BaseProjectileStrategy
class_name ProjectileDamageStrategy

@export var projectile_damage: float = 1.0

func get_desc() -> String:
	title = "Damage"
	description = "Increase projectile damage by [color=green]{0}[/color] damage"
	description = description.format([projectile_damage])
	return description

func apply_upgrade(projectile: Projectile):
	projectile.damage += projectile_damage
	return projectile