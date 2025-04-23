extends BasePlayerStatStrategy
class_name PlayerFirerateStrategy

@export var firerate: float = 0.1

func get_desc() -> String:
	title = "Firerate"
	description = "Increase Firerate by [color=green]{0}[/color]%"
	var converted_firerate = firerate * 100
	description = description.format([converted_firerate])
	return description

## Apply upgrade to player
func apply_upgrade(player: Player):
	player.base_attack_cooldown = player.base_attack_cooldown - player.base_attack_cooldown * firerate
	player.base_attack_cooldown = maxf(0.2, player.base_attack_cooldown)
	return firerate