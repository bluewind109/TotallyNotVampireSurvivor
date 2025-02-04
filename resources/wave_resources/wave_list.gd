extends Resource

class_name WaveList

@export var waves: Array[WaveData]

var current_wd: WaveData = null
var current_wd_index: int = 0; #current wave data index

func get_next_wave_data() -> WaveData:
	var index = current_wd_index
	print("[wave_list] get_next_wave_data: ", index)
	current_wd_index += 1
	
	if (current_wd_index >= waves.size()):
		return null
	
	SignalManager.on_show_wave_number.emit(current_wd_index)
	return waves[index]

func set_current_wave_data() -> void:
	print("[wave_list] set_current_wave_data")
	return

func get_current_wave_data_amount() -> int:
	print("[wave_list] get_current_wave_data_amount 1: ", waves.size())
	if (current_wd_index >= waves.size()):
		return 0;
	
	current_wd = waves[current_wd_index]
	if (current_wd == null): 
		return 0
	
	print("[wave_list] get_current_wave_data_amount 2: ", current_wd.amount)
	return current_wd.amount

func set_current_wave_data_amount(number: int) -> void:
	if (current_wd == null):
		return
		
	current_wd.amount = maxi(0, current_wd.amount - number)

func get_current_enemy_type() -> EnemyType:
	return current_wd.enemy_type
