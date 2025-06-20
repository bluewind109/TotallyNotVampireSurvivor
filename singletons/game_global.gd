extends Node

var player_ref: Player
func set_player_ref(ref: Player):
	player_ref = ref

var is_slow_mo_active: bool = false
var slow_mo_multiplier: float = 1.0
func toggle_slow_mo(multiplier: float):
	is_slow_mo_active = !is_slow_mo_active
	if (is_slow_mo_active == true):
		slow_mo_multiplier = multiplier
	else:
		slow_mo_multiplier = 1.0
	