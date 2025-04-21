extends NinePatchRect
class_name UpgradeSlot

@onready var label_upgrade_title: Label = $Title/LabelUpgradeTitle
@onready var upgrade_icon: TextureRect = $Container/UpgradeIcon
@onready var label_desc: RichTextLabel = $ContainerDesc/LabelDesc

var strategy: BaseProjectileStrategy
func set_strategy(val):
	strategy = val

func init(input_strat: BaseProjectileStrategy):
	set_strategy(input_strat)

func setup_UI(str_title: String, icon_texture: Texture2D, str_desc: String):
	label_upgrade_title.text = str_title
	upgrade_icon.texture = icon_texture
	label_desc.text = "[center][color=black]" + str_desc + "[/color][/center]"
	pass

func _on_label_desc_resized() -> void:
	# TODO Add label resize when overflow vertically (one day I will)
	pass # Replace with function body.

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		pass
	pass # Replace with function body.
