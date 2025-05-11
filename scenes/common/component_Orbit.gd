extends Node2D
class_name Component_Orbit

@export var radius: Vector2 = Vector2.ONE * 25
@export var rotation_duration: float = 4.0

@export var object_count: int = 4
@export var object_prefab: PackedScene
@export var object_texture: Texture2D
@export var object_scale: Vector2 = Vector2.ONE

var rotate_objects = []
var orbit_angle_offset = 0

func _ready() -> void:
	for i in object_count:
		var object_instance = object_prefab.instantiate() as Sprite2D
		if (object_texture): object_instance.texture = object_texture
		object_instance.scale = object_scale
		rotate_objects.append(object_instance)
		self.add_child(object_instance)

func _physics_process(delta: float) -> void:
	orbit_angle_offset += 2 * PI * delta / float(rotation_duration)
	orbit_angle_offset = wrapf(orbit_angle_offset, -PI, PI)
	_update_orbit()

func _update_orbit():
	if (rotate_objects.size() > 0):
		var spacing = 2 * PI / float(rotate_objects.size())
		for i in rotate_objects.size():
			var new_pos = Vector2()
			new_pos.x = cos(spacing * i + orbit_angle_offset) * radius.x
			new_pos.y = sin(spacing * i + orbit_angle_offset) * radius.x
			rotate_objects[i].position = new_pos

func set_enabled(val: bool):
	if (val):
		show()
		set_physics_process(true)
	else:
		hide()
		set_physics_process(false)
