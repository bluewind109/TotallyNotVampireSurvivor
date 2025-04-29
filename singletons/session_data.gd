extends Node

var player_data = {
	"health": 0.0,
	"movespeed": 0.0,
	"weapon_data": WeaponData
}

var weapon_data: WeaponData

func save_data(_player_data):
	player_data = _player_data
	print(_player_data)

func load_data():
	return player_data