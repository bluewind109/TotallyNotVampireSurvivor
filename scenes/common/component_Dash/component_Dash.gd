@icon("res://resources/icons/16x16/arrow_speed.png")
extends Node2D
class_name component_Dash

@export var dash_timer: Timer
@export var dash_cooldown_timer: Timer
@export var dash_particles: GPUParticles2D
@export var dash_cooldown_bar: TextureProgressBar

var can_dash: bool = true
var is_dashing: bool = false

const DASH_MULTIPLIER: float = 15.0

func _ready() -> void:
	toggle_dash_cooldown_bar(false)

func _process(_delta: float) -> void:
	if (not can_dash):
		dash_cooldown_bar.value = (dash_cooldown_timer.time_left / dash_cooldown_timer.wait_time) * 100

func activate():
	if (!can_dash): return
	can_dash = false
	toggle_dash_cooldown_bar(true)

	dash_timer.start()
	dash_cooldown_timer.start()

	is_dashing = true
	SignalManager.on_start_ghost_effect.emit()
	dash_particles.emitting = true

func get_dash_multiplier() -> float:
	return DASH_MULTIPLIER

func toggle_dash_cooldown_bar(is_show: bool):
	if (is_show):
		dash_cooldown_bar.show()
	else:
		dash_cooldown_bar.hide()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	SignalManager.on_stop_ghost_effect.emit()
	dash_particles.emitting = false

func _on_dash_cooldown_timer_timeout() -> void:
	toggle_dash_cooldown_bar(false)
	can_dash = true
