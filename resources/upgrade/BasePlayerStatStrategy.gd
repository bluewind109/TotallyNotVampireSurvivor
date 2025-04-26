extends BaseStrategy
class_name BasePlayerStatStrategy

var title: String
var description: String

## Update upgrade description. Damn it rhymes.
func get_desc() -> String:
	# Base func
	return description

## Apply upgrade to player
func apply_upgrade(_player: Player):
	return null
