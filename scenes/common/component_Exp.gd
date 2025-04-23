extends Node
class_name ComponentExp

@export var exp_bar: ProgressBar
@export var label_level: Label

@export var popup_level_up: PopupLevelUp
@export var current_weapon: BaseWeapon

# var OptionSlot = preload("res://scenes/option_slot/option_slot.tscn")

## EXP formula: curent level * base exp * multiplier 
var base_exp: float = 10.0
#var exp_req_multiplier: float  = 1.25
var exp_req_multiplier: float = 10.0 # cheat
var total_exp: float = 0
func set_total_exp(val: float) -> void:
	total_exp = val

var current_exp: float = 0.0
func set_current_exp(val: float) -> void:
	current_exp = val
	exp_bar.value = val

var level: int = 0
func set_level(val: int) -> void:
	level = val
	if (label_level): label_level.text = "Level %s" % str(level)
	#exp_bar.max_value = level * base_exp * exp_req_multiplier
	if (level > 20):
		exp_req_multiplier = 13.0
	elif (level > 40):
		exp_req_multiplier = 16.0
	else:
		exp_req_multiplier = 10.0
	
	exp_bar.max_value = base_exp + (level * exp_req_multiplier)
	if (level != 0): SignalManager.on_level_up.emit()
		
func _ready() -> void:
	SignalManager.on_pickup.connect(gain_exp)
	SignalManager.on_level_up.connect(level_up)
	
	set_level(0)
	
	# popup_level_up.hide_panel()
	popup_level_up.show_panel() # cheat
	
func _physics_process(_delta: float) -> void:
	check_XP()

func gain_exp(amount: float):
	# print("gain_exp: ", amount)
	set_current_exp(current_exp + amount)
	set_total_exp(total_exp + amount)

func check_XP():
	if (current_exp >= exp_bar.max_value):
		var previous_max_value = exp_bar.max_value
		set_level(level + 1)
		set_current_exp(current_exp - previous_max_value)

func close_option():
	popup_level_up.hide_panel()
	get_tree().paused = false
	pass
	
func clear_option():
	# if (upgrade_options.get_child_count() == 0): return
	# for option in upgrade_options.get_children():
	# 	option.queue_free()
	pass

func level_up():
	# if (!current_weapon.is_upgradable()): return
	# clear_option()

	# var option_slot = OptionSlot.instantiate()
	# option_slot.weapon = current_weapon
	# upgrade_options.add_child(option_slot)
	# upgrade_options.show()

	# particle_level_up.show()
	# particle_level_up.emitting = true
	# popup_level_up.show()
	# get_tree().paused = true
	pass
