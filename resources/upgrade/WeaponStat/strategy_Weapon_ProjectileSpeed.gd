extends BaseWeaponStrategy
class_name Strategy_Weapon_ProjectileSpeed

@export var projectile_speed: float = 0.05
func get_final_stat():
	return projectile_speed * get_rarity_multiplier()

func get_desc() -> String:
	title = "Projectile Speed"
	description = "Increase projectile speed by [color=green]{0}[/color]%"
	description = description.format([get_final_stat() * 100])
	return description
