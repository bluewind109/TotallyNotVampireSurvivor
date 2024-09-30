extends Resource
class_name Upgrade

@export var damage: float
@export var cooldown: float
var description: String

func update_desc():
	if (damage != 0): description += "+" + str(damage) + " Damage\n"
	if (cooldown != 0): description += str(cooldown) + "s Cooldown\n"
