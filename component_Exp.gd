extends Node
class_name ComponentExp

@export var exp_bar: ProgressBar
@export var label_level: Label

# EXP formula: curent level * base exp * multiplier 
var base_exp: float = 10.0
#var exp_req_multiplier: float  = 1.25
var exp_req_multiplier: float  = 10.0
var total_exp: float = 0

var current_exp: float = 0.0:
	set(value):
		current_exp = value
		exp_bar.value = value

var level: int = 0:
	set(value):
		level = value
		if (label_level): label_level.text = "Level %s" % str(level) 
		#exp_bar.max_value = level * base_exp * exp_req_multiplier
		if (level > 20):
			exp_req_multiplier = 13.0
		elif (level > 40):
			exp_req_multiplier = 16.0
		else:
			exp_req_multiplier  = 10.0
		
		exp_bar.max_value = base_exp + (level * exp_req_multiplier)
		if (level != 0): SignalManager.on_level_up.emit()

func _ready() -> void:
	SignalManager.on_pickup.connect(gain_XP)
	level = 0
	
func _physics_process(delta: float) -> void:
	check_XP()

func gain_XP(amount: float):
	current_exp += amount
	total_exp += amount

func check_XP():
	if (current_exp >= exp_bar.max_value):
		current_exp -= exp_bar.max_value
		level += 1
