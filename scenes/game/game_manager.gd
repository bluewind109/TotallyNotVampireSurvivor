extends Node2D

@export var pick_up_container: Node2D

func _ready() -> void:
	SignalManager.on_enemy_dead.connect(drop_item)
	pass

func drop_item(item: BasePickup) -> void:
	pick_up_container.call_deferred("add_child", item)
