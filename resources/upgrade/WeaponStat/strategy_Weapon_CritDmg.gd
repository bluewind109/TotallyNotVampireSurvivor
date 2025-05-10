extends BaseWeaponStrategy
class_name Strategy_Weapon_CritDmg

@export var crit_dmg: float = 0.1
func get_final_stat():
	return crit_dmg * get_rarity_multiplier()

func get_desc() -> String:
	title = "Critical Damage"
	description = "Increase critical damage by [color=green]{0}[/color]%"
	description = description.format([get_final_stat() * 100])
	return description