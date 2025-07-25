extends Control
class_name PauseMenu

@export var stat_panel: VBoxContainer
@export var stat_ui_prefab: PackedScene

var player_data

func _ready() -> void:
	hide()	

func load_stat_panel_data():
	player_data = SessionData.load_data().duplicate()

	if (player_data.weapon_data is GunData):
		player_data.weapon_data.get_all_stat()
		# print("player using gun ", player_data.weapon_data.stat_dict)
		for child in stat_panel.get_children():
			child.free()

		for stat in player_data.player_stat:
			print(stat, ": ", player_data.player_stat[stat])
			var stat_instance = stat_ui_prefab.instantiate() as StatUI
			stat_instance.set_data(stat, player_data.player_stat[stat])
			stat_panel.add_child(stat_instance)

		for stat in player_data.weapon_data.stat_dict:
			print(stat, ": ", player_data.weapon_data.stat_dict[stat])
			var stat_instance = stat_ui_prefab.instantiate() as StatUI
			stat_instance.set_data(stat, player_data.weapon_data.stat_dict[stat])
			stat_panel.add_child(stat_instance)


func _on_visibility_changed() -> void:
	if (visible):
		SignalManager.on_toggle_pause_menu.emit(true)
		load_stat_panel_data()
	else:
		SignalManager.on_toggle_pause_menu.emit(false)
