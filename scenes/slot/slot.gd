extends PanelContainer
class_name WeaponSlot

@export var weapon: Weapon:
	set(value):
		weapon = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown

var is_active: bool = false:
	set(value):
		is_active = value

func _on_cooldown_timeout() -> void:
	if (weapon):
		$Cooldown.wait_time = weapon.cooldown
		weapon.activate(owner, owner.nearest_enemy, get_tree())
