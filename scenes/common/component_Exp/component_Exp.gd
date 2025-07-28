@icon("res://resources/icons/16x16/xp.png")
extends Node2D
class_name Component_Exp

## EXP formula: curent level * base exp * multiplier 
var base_exp: float = 10.0
var required_exp: float = 10.0 ## total xp required to next level
var exp_req_multiplier: float  = 0.06
# var exp_req_multiplier: float = 10.0 # cheat
var total_exp: float = 0 ## total xp acquired this run
func set_total_exp(val: float) -> void:
	total_exp = val

var current_exp: float = 0.0
func set_current_exp(val: float) -> void:
	current_exp = val
	SignalManager.ui_update_exp_bar.emit(val)

var level: int = 0
func set_level(val: int) -> void:
	level = val
	required_exp = base_exp + base_exp * (level * exp_req_multiplier)
	print("required_exp: ", required_exp)
	SignalManager.ui_update_level.emit(level, required_exp)
	if (level > 0): 
		SignalManager.on_level_up.emit(level)
		
func _ready() -> void:
	SignalManager.on_pickup.connect(gain_exp)
	set_level.call_deferred(0)
	
func _physics_process(_delta: float) -> void:
	check_XP()

func gain_exp(amount: float):
	# print("gain_exp: ", amount)
	set_current_exp(current_exp + amount)
	set_total_exp(total_exp + amount)

func check_XP():
	if (current_exp >= required_exp):
		var previous_max_value = required_exp
		set_level(level + 1)
		set_current_exp(current_exp - previous_max_value)

# required_exp = level * base_exp * exp_req_multiplier
# if (level > 20):
# 	exp_req_multiplier = 13.0
# elif (level > 40):
# 	exp_req_multiplier = 16.0
# else:
# 	exp_req_multiplier = 10.0
# required_exp = base_exp + (level * exp_req_multiplier)
