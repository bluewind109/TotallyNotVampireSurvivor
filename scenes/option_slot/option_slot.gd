extends MarginContainer
class_name OptionSlot

@export var weapon: Weapon:
	set(value):
		weapon = value
		
		%ThumbnailTexture.texture = value.texture
		%Title.text = "Level " + str(weapon.level + 1)
		var upgrade: ProjectileUpgrade = value.upgrades[value.level - 1]
		upgrade.update_desc()
		%Description.text = upgrade.description

func _on_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("click") and weapon):
		print(weapon.title)
		weapon.upgrade_item()
		get_parent().close_option()
