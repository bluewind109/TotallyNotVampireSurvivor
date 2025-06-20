extends Area2D
class_name Component_SoftCollision

var overlapping_areas = Array()

func get_push_vector():
	var push_vector = Vector2.ZERO
	if (overlapping_areas):
		var random_dir_change = -1 if randf() < 0.5 else 1
		push_vector = overlapping_areas[0].global_position.direction_to(global_position).rotated(random_dir_change * PI/4)
		push_vector = push_vector.normalized()
	return push_vector

func is_colliding():
	overlapping_areas = get_overlapping_areas()
	return overlapping_areas != null
