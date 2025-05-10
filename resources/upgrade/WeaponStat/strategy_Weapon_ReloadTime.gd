extends BaseWeaponStrategy
class_name Strategy_Weapon_ReloadTime

@export var reload_time: float = -0.05
func get_final_stat():
	return reload_time * get_rarity_multiplier()

func get_desc() -> String:
	title = "Reload Time"
	description = "Reduce reload time by [color=green]{0}[/color]%"
	description = description.format([abs(get_final_stat()) * 100])
	return description