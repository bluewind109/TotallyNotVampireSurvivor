extends CanvasLayer

@export var label_wave: Label
@export var label_wave_timer: Timer
@onready var label_ammo_count: Label = %LabelAmmoCount

@export var pause_menu: PauseMenu
@export var popup_level_up: PopupLevelUp


func _ready() -> void:
	SignalManager.on_show_wave_number.connect(show_wave_number)
	SignalManager.ui_update_ammo_count.connect(update_ammo_count)
	SignalManager.on_toggle_pause_menu.connect(on_pause_menu_visibility_changed)
	SignalManager.on_toggle_popup_levelup.connect(on_popup_levelup_visibility_changed)
	label_wave.hide()
	# popup_level_up.hide_panel()
	popup_level_up.show_panel() # cheat

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("exit")):
		if (not pause_menu.visible):
			pause_menu.show()
		else:
			pause_menu.hide()

func show_wave_number(wave_num: int) -> void:
	label_wave_timer.start()
	label_wave.show()
	label_wave.text = "Wave %s" % (wave_num + 1)
	# print("show_wave_number wave_num: ", wave_num)
	# print("show_wave_number: ", label_wave.text)

func update_ammo_count(current_ammo: int, max_ammo: int):
	# print("update_ammo_count")
	label_ammo_count.text = "{0}/{1}".format([current_ammo, max_ammo])

func _on_label_wave_timer_timeout() -> void:
	label_wave.hide()

func on_pause_menu_visibility_changed(val: bool):
	if (not val):
		if (not popup_level_up.visible): 
			get_tree().paused = false
	else:
		get_tree().paused = true

func on_popup_levelup_visibility_changed(val: bool):
	if (not val):
		get_tree().paused = false
	else:
		get_tree().paused = true
