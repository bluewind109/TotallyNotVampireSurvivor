extends MarginContainer
class_name PopupLevelUp

@export var particle_level_up: GPUParticles2D
@export var upgrade_container: HBoxContainer
@export var upgrade_slot_prefab: PackedScene

@export var upgrade_type: Array[BaseStrategy]

var upgrade_number: int = 3

func _ready() -> void:
	SignalManager.on_level_up.connect(show_panel)
	SignalManager.on_stat_upgrade_selected.connect(on_upgrade_selected)

func show_panel():
	if not is_node_ready():
		await ready

	for child in upgrade_container.get_children():
		child.free()
	show()
	particle_level_up.emitting = true
	
	var upgrades = UpgradeConfig.get_random_upgrades(upgrade_number)
	for i in upgrades.size():
		show_upgrade(UpgradeConfig.UPGRADE_TYPE.values()[upgrades[i]])
	get_tree().paused = true
	return

func show_upgrade(type: UpgradeConfig.UPGRADE_TYPE):
	var slot = upgrade_slot_prefab.instantiate() as UpgradeSlot
	slot.init(upgrade_type[type])
	upgrade_container.add_child(slot)

func on_upgrade_selected(_val: BaseStrategy):
	hide_panel()
	
func hide_panel():
	hide()
	particle_level_up.emitting = false
	get_tree().paused = false
