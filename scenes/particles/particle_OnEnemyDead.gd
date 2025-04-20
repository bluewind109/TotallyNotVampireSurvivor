extends GPUParticles2D

@onready var timeCreated = Time.get_ticks_msec()

func _ready() -> void:
	if (Time.get_ticks_msec() - timeCreated > 10 * 1000):
		queue_free()
