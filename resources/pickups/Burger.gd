extends Pickups
class_name Burger

@export var XP: float

# player gains EXP
func activate():
	super.activate()
	#prints("+" + str(XP) + "XP")
	#player_ref.gain_XP(XP)
	SignalManager.on_pickup.emit(XP)
