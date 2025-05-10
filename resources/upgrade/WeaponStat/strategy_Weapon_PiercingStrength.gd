extends BaseWeaponStrategy
class_name Strategy_Weapon_PiercingStrength

@export var pierce_strength: int = 1

func get_desc() -> String:
	title = "Pierce"
	description = "Increase Pierce Strength by [color=green]{0}[/color]"
	description = description.format([pierce_strength])
	return description
