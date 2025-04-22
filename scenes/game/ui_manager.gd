extends CanvasLayer

@export var label_wave: Label
@export var label_wave_timer: Timer

func _ready() -> void:
	SignalManager.on_show_wave_number.connect(show_wave_number)
	show_wave_number(0)
	label_wave.visible = false

func show_wave_number(wave_num: int) -> void:
	label_wave_timer.start()
	label_wave.visible = true
	label_wave.text = "Wave %s" % (wave_num + 1)
	print("show_wave_number wave_num: ", wave_num)
	print("show_wave_number: ", label_wave.text)

func _on_label_wave_timer_timeout() -> void:
	label_wave.visible = false
