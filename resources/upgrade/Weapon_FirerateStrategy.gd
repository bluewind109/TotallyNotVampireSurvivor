extends BaseWeaponStrategy
class_name WeaponFirerateStrategy

@export var firerate: float = 0.1
func get_final_stat():
	return firerate * get_rarity_multiplier()

func get_desc() -> String:
	title = "Firerate"
	description = "Increase Firerate by [color=green]{0}[/color]%"
	var converted_stat = get_final_stat() * 100
	description = description.format([converted_stat])
	return description
