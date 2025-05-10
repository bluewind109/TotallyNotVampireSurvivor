extends BaseWeaponStrategy
class_name Strategy_Weapon_Damage

@export var projectile_damage: float = 0.1
func get_final_stat():
	return projectile_damage * get_rarity_multiplier()

func get_desc() -> String:
	title = "Damage"
	description = "Increase projectile damage by [color=green]{0}[/color]%"
	description = description.format([get_final_stat() * 100])
	return description
