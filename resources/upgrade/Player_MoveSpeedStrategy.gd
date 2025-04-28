extends BasePlayerStatStrategy
class_name PlayerMoveSpeedStrategy

@export var additional_movespeed: float = 10.0

func get_desc() -> String:
	title = "Movement Speed"
	description = "Increase Movement Speed by [color=green]{0}[/color]"
	description = description.format([additional_movespeed])
	return description