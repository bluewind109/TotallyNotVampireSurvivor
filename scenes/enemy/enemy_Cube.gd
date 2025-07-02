extends Enemy
class_name EnemyCube

func apply_mini_boss_effect() -> void:
	super.apply_mini_boss_effect()
	set_health(health * 100)

func _ready() -> void:
	super._ready()
