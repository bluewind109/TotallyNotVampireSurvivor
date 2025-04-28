extends BaseWeaponStrategy
class_name WeaponDamageStrategy

@export var projectile_damage: float = 0.1

func get_desc() -> String:
	title = "Damage"
	description = "Increase projectile damage by [color=green]{0}[/color]%"
	description = description.format([projectile_damage * 100])
	return description
