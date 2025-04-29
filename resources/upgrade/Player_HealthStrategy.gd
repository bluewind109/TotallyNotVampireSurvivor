extends BasePlayerStatStrategy
class_name PlayerHealthStrategy

@export var additional_health: float = 10.0
func get_final_stat():
	return additional_health * get_rarity_multiplier()

func get_desc() -> String:
	title = "Health"
	description = "Increase Health by [color=green]{0}[/color]"
	description = description.format([get_final_stat()])
	return description
