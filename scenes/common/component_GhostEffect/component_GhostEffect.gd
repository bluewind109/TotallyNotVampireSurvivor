extends Node2D
class_name component_GhostEffect

@export var ghost_timer: Timer
@export var ghost_effect_prefab: PackedScene
@export var sprite_2d: Sprite2D

func _ready() -> void:
	SignalManager.on_start_ghost_effect.connect(start_effect)
	SignalManager.on_stop_ghost_effect.connect(stop_effect)

func start_effect() -> void:
	ghost_timer.start()

func stop_effect() -> void:
	ghost_timer.stop()

func tween_ghost_effect() -> void:
	print("[component_GhostEffect] tween_ghost_effect")
	var ghost_effect = ghost_effect_prefab.instantiate() as Sprite2D
	ghost_effect.set_property(
		global_position, 
		sprite_2d.scale
	)
	#ghost_effect.set_frames(player_sprite.sprite_frames)
	ghost_effect.texture = sprite_2d.texture
	#ghost_effect.set_anim(PLAYER_ANIM.RUN)
	# self.add_child(ghost_effect)
	get_tree().current_scene.add_child(ghost_effect)
	
func _on_ghost_timer_timeout() -> void:
	tween_ghost_effect()
