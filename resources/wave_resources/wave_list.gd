extends Resource

class_name WaveList

@export var waves: Array[WaveData]

var current_wd: WaveData = null
var current_wd_index: int = 0; #current wave data index

func get_next_wave_data() -> WaveData:
	if (current_wd_index == waves.size()):
		return null
	
	var index = current_wd_index
	current_wd_index += 1
	
	SignalManager.on_show_wave_number.emit(current_wd_index)
	return waves[index]

func set_current_wave_data() -> void:
	return

func get_current_wave_data_amount() -> int:
	if (current_wd == null): return 0
	
	var _current_wave_data: WaveData = waves[current_wd_index]
	return _current_wave_data.amount

func get_current_enemy_type() -> EnemyType:
	return current_wd.enemy_type
