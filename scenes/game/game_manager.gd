extends Node2D

@export var pick_up_container: Node2D
@export var player_projectile_container: Node2D
@export var enemy_projectile_container: Node2D
@export var damage_popup_container: Node2D
@export var damage_popup_node: PackedScene

@export var player: Player
@export var spawn_manager: SpawnManager

func _ready() -> void:
	SignalManager.on_enemy_dead.connect(drop_item)
	SignalManager.ui_show_damage.connect(show_damage_popup)
	SignalManager.on_projectile_spawn.connect(spawn_projectile)

	if (!player.is_node_ready()):
		await player.ready
	if (!spawn_manager.is_node_ready()):
		await spawn_manager.ready
	
	spawn_manager.init()
	

func drop_item(item: BasePickup) -> void:
	pick_up_container.add_child.call_deferred(item)

func spawn_projectile(projectile, is_enemy_projectile: bool = false):
	if (is_enemy_projectile == false):
		player_projectile_container.add_child.call_deferred(projectile)
	else:
		enemy_projectile_container.add_child.call_deferred(projectile)

func show_damage_popup(spawn_position: Vector2, damage: float, is_crit: bool):
	var popup_instance = damage_popup_node.instantiate() as DamageText
	popup_instance.text = str(damage)
	if (is_crit):
		popup_instance.label_settings.font_color = Color(1, 1, 0, 1) # yellow
	else:
		popup_instance.label_settings.font_color = Color(1, 1, 1, 1) # white

	popup_instance.position = spawn_position + Vector2(-50, -25)
	damage_popup_container.add_child(popup_instance)
