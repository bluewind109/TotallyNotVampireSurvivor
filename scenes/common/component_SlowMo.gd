@icon("res://resources/icons/16x16/arrow_rotate_anticlockwise.png")
extends Node
class_name Component_SlowMo

@export var slow_mo_timer: Timer

var slow_mo_multiplier: float = 0.1

func _ready() -> void:
	pass

func toggle_slow_mo():
	if(GameGlobal.is_slow_mo_active == false):
		GameGlobal.toggle_slow_mo(true, slow_mo_multiplier)
		slow_mo_timer.start()
		# TODO trigger sound effect
	# SignalManager.toggle_slow_mo_effect.emit(true, slow_mo_multiplier)

func _on_slow_mo_timer_timeout() -> void:
	GameGlobal.toggle_slow_mo(false)
