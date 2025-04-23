extends MarginContainer
class_name PopupLevelUp

@export var particle_level_up: GPUParticles2D
@export var upgrade_container: HBoxContainer
@export var upgrade_slot_prefab: PackedScene

@export var upgrade_type: Array[BasePlayerStatStrategy]

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
	
	# var slot_1 = upgrade_slot_prefab.instantiate() as UpgradeSlot
	# slot_1.init(upgrade_type[UpgradeConfig.UPGRADE_TYPE.Damage])
	# upgrade_container.add_child(slot_1)

	# var slot_2 = upgrade_slot_prefab.instantiate() as UpgradeSlot
	# slot_2.init(upgrade_type[UpgradeConfig.UPGRADE_TYPE.ProjectileSpeed])
	# upgrade_container.add_child(slot_2)

	var slot_3 = upgrade_slot_prefab.instantiate() as UpgradeSlot
	slot_3.init(upgrade_type[UpgradeConfig.UPGRADE_TYPE.Health])
	upgrade_container.add_child(slot_3)
	
	var slot_4 = upgrade_slot_prefab.instantiate() as UpgradeSlot
	slot_4.init(upgrade_type[UpgradeConfig.UPGRADE_TYPE.MoveSpeed])
	upgrade_container.add_child(slot_4)

	get_tree().paused = true
	return

func on_upgrade_selected(_val: BasePlayerStatStrategy):
	hide_panel()
	
func hide_panel():
	hide()
	particle_level_up.emitting = false
	get_tree().paused = false
