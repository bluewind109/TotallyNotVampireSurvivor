extends MarginContainer
class_name PopupLevelUp

@export var particle_level_up: GPUParticles2D
@export var upgrade_container: HBoxContainer
@export var upgrade_slot_prefab: PackedScene
@export var anim_player: AnimationPlayer

@export var upgrade_type: Array[BaseStrategy]

var upgrade_number: int = 3
var is_popup_show_anim_finished: bool = false
var is_init: bool = false

func _ready() -> void:
	SignalManager.on_level_up.connect(show_panel)
	SignalManager.on_stat_upgrade_selected.connect(on_upgrade_selected)

func show_panel():
	is_popup_show_anim_finished = false
	is_init = false
	if not is_node_ready():
		await ready

	print("show_panel 1")
	anim_player.play.call_deferred("popup_show")
	for child in upgrade_container.get_children():
		child.free()
	show()
	particle_level_up.emitting = true

	var rarities: Array[String] = UpgradeConfig.get_rarities(upgrade_number)
	# for rarity in rarities:
	# 	var upgrade = UpgradeConfig.get_random_upgrade_with_rarity(rarity)
	# 	show_upgrade(upgrade)

	# for i in 50:
	# 	UpgradeConfig.get_random_upgrades_with_rarity(
	# 	upgrade_number, rarities)

	await anim_player.animation_finished
	print("show_panel 2")

	var upgrades: Array[int] = UpgradeConfig.get_random_upgrades_with_rarity(
		upgrade_number, rarities)
	# print(upgrades)
	for upgrade in upgrades:
		show_upgrade(UpgradeConfig.UPGRADE_TYPE.values()[upgrade])
		await get_tree().create_timer(0.15).timeout
		# print(upgrade)
	
	is_init = true
	print("show_panel 3")

	# var upgrades = UpgradeConfig.get_random_upgrades(upgrade_number)
	# for upgrade in upgrades.size():
	# 	show_upgrade(UpgradeConfig.UPGRADE_TYPE.values()[upgrade])
	get_tree().paused = true
	return

func show_upgrade(type: UpgradeConfig.UPGRADE_TYPE):
	var slot = upgrade_slot_prefab.instantiate() as UpgradeSlot
	var rarity: String = UpgradeConfig.get_rarity()
	slot.init(upgrade_type[type], rarity)
	upgrade_container.add_child(slot)

func on_upgrade_selected(_val: BaseStrategy):
	hide_panel()
	
func hide_panel():
	hide()
	particle_level_up.emitting = false
	get_tree().paused = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "popup_show"):
		is_popup_show_anim_finished = true
		anim_player.animation_finished.emit()


	pass # Replace with function body.
