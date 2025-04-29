extends Control
class_name PauseMenu

@export var stat_panel: Panel
@export var stat_ui_prefab: StatUI

var player_data

func _ready() -> void:
	hide()	

func load_stat_panel_data():
	player_data = SessionData.load_data().duplicate()

	if (player_data.weapon_data is GunData):
		print("player using gun")


func _on_visibility_changed() -> void:
	if (visible):
		SignalManager.on_toggle_pause_menu.emit(true)
		load_stat_panel_data()
	else:
		SignalManager.on_toggle_pause_menu.emit(false)
