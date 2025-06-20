extends Node
class_name Component_SlowMo

@export var slow_mo_timer: Timer

var is_slow_mo_active: bool = false
var slow_mo_multiplier: float = 0.25

func _ready() -> void:
	pass

func toggle_slow_mo():
	GameGlobal.toggle_slow_mo(slow_mo_multiplier)
	# SignalManager.toggle_slow_mo_effect.emit(true, slow_mo_multiplier)
