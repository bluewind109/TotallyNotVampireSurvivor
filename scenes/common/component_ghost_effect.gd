extends Sprite2D

class_name GhostEffect

func _ready():
	ghosting()

#func set_frames(frames: SpriteFrames) -> void:
	#sprite_frameas = frames
	#
#func set_anim(anim_name: String) -> void:
	#play(anim_name)

func set_property(tx_pos: Vector2, tx_scale: Vector2, offset: Vector2 = Vector2.ZERO):
	position = tx_pos + offset
	scale = tx_scale

func ghosting():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(
		self, 
		"self_modulate", 
		Color(1, 1, 1, 0), 
		0.75
	)
	await tween_fade.finished
	queue_free()
	
