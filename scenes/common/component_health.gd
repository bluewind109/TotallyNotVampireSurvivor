@icon("res://resources/icons/16x16/heart.png")
extends Node2D
class_name Component_Health

signal died
signal on_update_health(amount: float)
signal on_update_max_health(amount: float)

var health: float = 10.0:
	set(value):
		if not is_node_ready():
			await ready
		health = value
		on_update_health.emit(health)

var max_health: float = 10.0
func set_max_health(val):
	max_health = val
	SessionData.save_player_stat(UpgradeConfig.UPGRADE_ID.Health, max_health)
	on_update_max_health.emit(max_health)

func increase_max_health(val):
	max_health += val
	SessionData.save_player_stat(UpgradeConfig.UPGRADE_ID.Health, max_health)
	on_update_max_health.emit(max_health)
	health += val

func init(_max_health: float) -> void:
	health = _max_health
	set_max_health(_max_health)

func take_damage(amount: float):
	# print_debug("take_damage: ", amount)
	health -= amount
	if (health <= 0): died.emit()
