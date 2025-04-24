extends BasePlayerStatStrategy
class_name PlayerPiercingStrength

@export var pierce_strength: int = 1

func get_desc() -> String:
	title = "Pierce"
	description = "Increase Pierce Strength by [color=green]{0}[/color]"
	description = description.format([pierce_strength])
	return description

## Apply upgrade to player
func apply_upgrade(player: Player):
	player.set_piercing_strength(pierce_strength)
	return pierce_strength
