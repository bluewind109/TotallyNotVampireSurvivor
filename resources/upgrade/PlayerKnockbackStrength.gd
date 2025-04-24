extends BasePlayerStatStrategy
class_name PlayerKnockbackStrength

@export var kb_strength: float = 10.0

func get_desc() -> String:
	title = "Knockback"
	description = "Increase Knockback by [color=green]{0}[/color]"
	description = description.format([kb_strength])
	return description

## Apply upgrade to player
func apply_upgrade(player: Player):
	player.set_knockback_strength(kb_strength)
	return kb_strength
