extends NinePatchRect
class_name UpgradeSlot

@export var label_upgrade_title: Label
@export var upgrade_icon: TextureRect
@export var label_desc: RichTextLabel

var strategy: BaseProjectileStrategy
func set_strategy(val):
	strategy = val

func init(input_strat: BaseProjectileStrategy):
	# if not is_node_ready():
	# 	await ready
	set_strategy(input_strat)
	setup_UI()

func setup_UI():
	# print("setup_UI " + str_title)
	strategy.get_desc()
	label_upgrade_title.text = strategy.title
	# if (icon_texture != null): upgrade_icon.texture = null
	label_desc.text = "[center][color=black]" + strategy.description + "[/color][/center]"

func _on_label_desc_resized() -> void:
	# TODO Add label resize when overflow vertically (one day I will)
	pass # Replace with function body.

func _on_gui_input(event: InputEvent) -> void:
	# Apply upgrade on select
	if (event is InputEventMouseButton  and 
		event.is_released() and 
		event.button_index == MOUSE_BUTTON_LEFT):
		SignalManager.on_upgrade_selected.emit(strategy)
