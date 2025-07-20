extends Node

const GROUP: Dictionary[String, String] = {
	"Enemy": "Enemy",
	"Player": "Player",
	"PlayerHitbox": "PlayerHitbox",
}

var player_ref: Player
func set_player_ref(ref: Player):
	player_ref = ref

var is_slow_mo_active: bool = false
var slow_mo_multiplier: float = 1.0
func toggle_slow_mo(is_on: bool, multiplier: float = 1.0):
	is_slow_mo_active = is_on
	slow_mo_multiplier = multiplier

# probably should be in Utils class
func pick_random(dictionary: Dictionary) -> Variant:
	var random_key = dictionary.keys().pick_random()
	return dictionary[random_key]