extends Resource

class_name WaveList

@export var waves: Array[WaveData]

var current_wave: int = 0;

func get_next_wave() -> WaveData:
	if (current_wave == waves.size()):
		current_wave = 0
	
	var index = current_wave
	current_wave += 1
	
	SignalManager.on_show_wave_number.emit(current_wave)
	return waves[index]
