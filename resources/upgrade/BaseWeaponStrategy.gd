extends BaseStrategy
class_name BaseWeaponStrategy

var title: String
var description: String

## Update upgrade description. Damn it rhymes.
func get_desc() -> String:
	# Base func
	return description

## Apply upgrade to weapon
func apply_upgrade(_player: Player):
	_player.component_weapon.apply_upgrade(self)
