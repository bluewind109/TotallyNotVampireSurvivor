extends BaseWeaponStrategy
class_name WeaponFirerateStrategy

@export var firerate: float = 0.1

func get_desc() -> String:
	title = "Firerate"
	description = "Increase Firerate by [color=green]{0}[/color]%"
	var converted_firerate = firerate * 100
	description = description.format([converted_firerate])
	return description
