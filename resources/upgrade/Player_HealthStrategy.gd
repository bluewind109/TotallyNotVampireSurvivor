extends BasePlayerStatStrategy
class_name PlayerHealthStrategy

@export var additional_health: float = 10.0

func get_desc() -> String:
	title = "Health"
	description = "Increase Health by [color=green]{0}[/color]"
	description = description.format([additional_health])
	return description
