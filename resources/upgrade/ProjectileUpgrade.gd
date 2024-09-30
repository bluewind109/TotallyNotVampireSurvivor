extends Upgrade
class_name ProjectileUpgrade

@export var speed: float

func update_desc():
	super.update_desc()
	if (speed != 0): description += "+" + str(speed) + " speed\n"
