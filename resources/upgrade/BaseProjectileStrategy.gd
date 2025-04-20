extends Resource
class_name BaseProjectileStrategy

@export var damage: float
@export var cooldown: float
var description: String

## Update upgrade description. Damn it rhymes.
func update_desc():
	if (damage != 0): description += "+" + str(damage) + " Damage\n"
	if (cooldown != 0): description += str(cooldown) + "s Cooldown\n"


func apply_upgrade():
	# Base function. Do nothing.
	pass
