extends Node

var player_data: Dictionary[String, Variant] = {
	"player_stat": {
		"Health": 0.0,
		"Movespeed": 0.0,
	},
	"weapon_data": WeaponData
}

var weapon_data: WeaponData

func save_data(_player_data: Dictionary[String, Variant]):
	player_data = _player_data
	print("save_data ", _player_data)

func load_data():
	return player_data