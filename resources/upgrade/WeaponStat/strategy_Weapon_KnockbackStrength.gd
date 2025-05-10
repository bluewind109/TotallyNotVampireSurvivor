extends BaseWeaponStrategy
class_name Strategy_Weapon_KnockbackStrength

@export var kb_strength: float = 0.1
func get_final_stat():
	return kb_strength * get_rarity_multiplier()

func get_desc() -> String:
	title = "Knockback"
	description = "Increase Knockback by [color=green]{0}[/color]%"
	description = description.format([get_final_stat() * 100])
	return description
