extends Resource

class_name WaveList

@export var waves: Array[WaveData]

var current_sub_wave: int = 0;

func get_next_sub_wave() -> WaveData:
	if (current_sub_wave == waves.size()):
		current_sub_wave = 0
	
	var index = current_sub_wave
	current_sub_wave += 1
	
	SignalManager.on_show_wave_number.emit(current_sub_wave)
	return waves[index]
