extends CanvasLayer

@onready var label_wave: Label = $MarginContainer/LabelWave
@onready var label_wave_timer: Timer = $LabelWaveTimer

func _ready() -> void:
	SignalManager.on_show_wave_number.connect(show_wave_number)
	label_wave.visible = false;

func _process(delta: float) -> void:
	pass

func show_wave_number(wave_num: int) -> void:
	label_wave_timer.start()
	label_wave.visible = true;
	label_wave.text = "Wave %s" % wave_num

func _on_label_wave_timer_timeout() -> void:
	label_wave.visible = false;
