extends BaseWeaponStrategy
class_name Strategy_Weapon_MaxAmmo

@export var max_ammo: float = 0.1
func get_final_stat():
	return max_ammo * get_rarity_multiplier()

func get_desc() -> String:
	title = "Max Ammo"
	description = "Increase Max Ammo by [color=green]{0}[/color]%"
	var converted_stat = get_final_stat() * 100
	print("max ammo ", converted_stat)
	description = description.format([converted_stat])
	return description
