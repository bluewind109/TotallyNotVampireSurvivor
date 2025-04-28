extends BaseWeaponStrategy
class_name WeaponKnockbackStrength

@export var kb_strength: float = 0.1

func get_desc() -> String:
	title = "Knockback"
	description = "Increase Knockback by [color=green]{0}[/color]%"
	description = description.format([kb_strength * 100])
	return description
