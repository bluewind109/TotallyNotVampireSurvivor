extends Node2D
class_name component_Dash

@export var dash_timer: Timer
@export var dash_cooldown_timer: Timer
@export var dash_particles: GPUParticles2D
@export var dash_cooldown_bar: TextureProgressBar

@export var component_ghost: PackedScene

var can_dash: bool = true
var is_dashing: bool = false

const DASH_MULTIPLIER: float = 15.0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if (not can_dash):
		dash_cooldown_bar.value = (dash_cooldown_timer.time_left / dash_cooldown_timer.wait_time) * 100

func activate():
	if (!can_dash): return
	can_dash = false
	is_dashing = true
	dash_cooldown_timer.start()
	dash_timer.start()
	# ghost_timer.start()
	dash_particles.emitting = true
	dash_cooldown_bar.show()

func get_dash_multiplier() -> float:
	return DASH_MULTIPLIER

func _on_dash_cooldown_timer_timeout() -> void:
	dash_cooldown_bar.hide()
	can_dash = true
