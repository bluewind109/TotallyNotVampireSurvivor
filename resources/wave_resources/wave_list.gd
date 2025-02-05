extends Resource

class_name WaveList

@export var waves: Array[WaveData]

var current_wd: WaveData = null
var current_wd_index: int = 0 #current wave data index
var current_wd_amount: int = 0

func _ready() -> void:
	current_wd_index = 0

func set_current_WD() -> WaveData:
	current_wd = waves[current_wd_index]
	current_wd_amount = current_wd.amount
	return current_wd

func get_next_WD() -> WaveData:
	current_wd_index += 1
	set_current_WD()
	
	print("[wave_list] get_next_WD")
	return current_wd

func get_current_WD_amount() -> int:
	#print("[wave_list] get_current_WD_amount 1: ", waves.size())
	print("[wave_list] get_current_WD_amount 2: ", current_wd_amount)
	return current_wd_amount

func set_current_WD_amount(number: int) -> void:
	if (current_wd == null):
		return
		
	current_wd_amount = maxi(0, current_wd_amount - number)

func get_current_enemy_type() -> EnemyType:
	return current_wd.enemy_type

func is_last_WD() -> bool:
	return current_wd_index >= waves.size()
