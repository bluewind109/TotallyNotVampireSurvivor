extends NinePatchRect
class_name UpgradeSlot

@export var label_upgrade_title: Label
@export var upgrade_icon: TextureRect
@export var label_desc: RichTextLabel

# @export var rarity_color: Array[Color] = UpgradeConfig.RARITY_COLOR
@export var rarity_frame: NinePatchRect

var strategy: BaseStrategy
func set_strategy(val: BaseStrategy, rarity: String):
	strategy = val
	strategy.set_rarity(rarity)

func init(input_strat: BaseStrategy, rarity: String):
	# if not is_node_ready():
	# 	await ready
	set_strategy(input_strat, rarity)
	setup_UI()

func setup_UI():
	# print("setup_UI " + str_title)
	strategy.get_desc()
	label_upgrade_title.text = strategy.title
	# if (icon_texture != null): upgrade_icon.texture = null
	label_desc.text = "[center][color=black]" + strategy.description + "[/color][/center]"

	if (strategy is WeaponPiercingStrength):
		rarity_frame.self_modulate = UpgradeConfig.get_rarity_color(UpgradeConfig.RARITY_ID.Rare)
	else:
		rarity_frame.self_modulate = UpgradeConfig.get_rarity_color(strategy.rarity)

func _on_label_desc_resized() -> void:
	# TODO Add label resize when overflow vertically (one day I will)
	pass # Replace with function body.

func _on_gui_input(event: InputEvent) -> void:
	# Apply upgrade on select
	if (event is InputEventMouseButton  and 
		event.is_released() and 
		event.button_index == MOUSE_BUTTON_LEFT):
		SignalManager.on_stat_upgrade_selected.emit(strategy)
