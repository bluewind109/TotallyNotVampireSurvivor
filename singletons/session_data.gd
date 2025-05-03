extends Node

var player_data: Dictionary[String, Variant] = {
	"player_stat": {
		UpgradeConfig.UPGRADE_ID.Health: 0.0,
		UpgradeConfig.UPGRADE_ID.MoveSpeed: 0.0,
	},
	"weapon_data": WeaponData
}

# var player_stat: Dictionary[String, Variant]
# var weapon_data: WeaponData

func save_data(_player_data: Dictionary[String, Variant]):
	player_data = _player_data
	print("save_data ", _player_data)

func load_data():
	return player_data

func save_all_player_stats():
	pass
	
func save_player_stat(stat_key: String, stat_value: Variant):
	player_data.player_stat[stat_key] = stat_value

func load_player_stat(stat_key: String) -> Variant:
	if (player_data.player_stat.has(stat_key)): return null
	return player_data.player_stat[stat_key]

func save_weapon_stat(stat_key: String, stat_value: Variant):
	player_data.weapon_data[stat_key] = stat_value

func load_weapon_stat(stat_key: String) -> Variant:
	if (player_data.weapon_data.has(stat_key)): return null
	return player_data.weapon_data[stat_key]

