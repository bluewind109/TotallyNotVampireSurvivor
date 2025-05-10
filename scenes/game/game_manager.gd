extends Node2D

@export var pick_up_container: Node2D
@export var damage_popup_container: Node2D
@export var damage_popup_node: PackedScene

func _ready() -> void:
	SignalManager.on_enemy_dead.connect(drop_item)
	SignalManager.ui_show_damage.connect(show_damage_popup)

func drop_item(item: BasePickup) -> void:
	pick_up_container.add_child.call_deferred(item)

func show_damage_popup(spawn_position: Vector2, damage: float, is_crit: bool):
	var popup_instance = damage_popup_node.instantiate() as DamagePopup
	popup_instance.text = str(damage)
	if (is_crit):
		popup_instance.label_settings.font_color = Color(1, 1, 0, 1) # yellow
	else:
		popup_instance.label_settings.font_color = Color(1, 1, 1, 1) # white

	popup_instance.position = spawn_position + Vector2(-50, -25)
	damage_popup_container.add_child(popup_instance)
