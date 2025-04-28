extends BaseWeaponStrategy
class_name WeaponProjectileSpeedStrategy

@export var projectile_speed: float = 0.05

func get_desc() -> String:
	title = "Speed"
	description = "Increase projectile speed by [color=green]{0}[/color]%"
	description = description.format([projectile_speed * 100])
	return description
