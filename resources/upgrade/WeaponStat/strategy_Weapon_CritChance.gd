extends BaseWeaponStrategy
class_name Strategy_Weapon_CritChance

@export var crit_chance: float = 0.1
func get_final_stat():
	return crit_chance * get_rarity_multiplier()

func get_desc() -> String:
	title = "Critical Chance"
	description = "Increase critical chance by [color=green]{0}[/color]%"
	description = description.format([get_final_stat() * 100])
	return description