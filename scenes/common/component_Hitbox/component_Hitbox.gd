extends Area2D
class_name component_Hitbox

@export var owner_ref: Node2D

signal take_damage(
	damage: float, 
	knockback_strength: float, 
	direction: Vector2, 
	is_crit: bool
)

func toggle_collision(val: bool):
	self.set_deferred("monitoring", val)

func _on_body_entered(body: Node2D) -> void:
	# print("[componenet_Hitbox] _on_body_entered")
	if (owner_ref == null): return
	if ("damage" in body):
		# print("_on_body_entered")
		var kb_strength: float = 0.0
		var kb_direction: Vector2 = Vector2.RIGHT
		var is_crit: bool = false
		if ("knockback" in body): kb_strength = body.knockback
		if ("direction" in body): kb_direction = body.direction
		if ("is_crit" in body): is_crit = body.is_crit
		take_damage.emit(body.damage, kb_strength, kb_direction, is_crit)

func _on_area_entered(area: Area2D) -> void:
	if (owner_ref == null): return
	if ("damage" in area):
		# print("_on_area_entered")
		var kb_strength: float = 0.0
		var kb_direction: Vector2 = Vector2.RIGHT
		var is_crit: bool = false
		if ("knockback" in area): kb_strength = area.knockback
		if ("direction" in area): kb_direction = area.direction
		if ("is_crit" in area): is_crit = area.is_crit
		take_damage.emit(area.damage, kb_strength, kb_direction, is_crit)
