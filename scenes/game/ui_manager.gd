extends CanvasLayer

@export var label_wave: Label
@export var label_wave_timer: Timer
@onready var label_ammo_count: Label = %LabelAmmoCount

func _ready() -> void:
	SignalManager.on_show_wave_number.connect(show_wave_number)
	SignalManager.ui_update_ammo_count.connect(update_ammo_count)
	label_wave.hide()

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
