extends Node
class_name Component_Health

@export var health_bar: TextureProgressBar
@export var label_health: Label

signal died

var level_low: float = 0.30
var level_med: float = 0.65
var start_health: float = 100.0

var health: float = 100.0:
	set(value):
		if not is_node_ready():
			await ready
		health = value
		update_health_bar()
# func set_health(val: float) -> void:
# 	health = val
# 	health_bar.value = val

var max_health: float = 100.0
func set_max_health(val):
	max_health += val
	SessionData.save_player_stat(UpgradeConfig.UPGRADE_ID.Health, max_health)
	update_max_health_bar()
	health += val

const COLOR_DANGER: Color = Color("#cc0000")
const COLOR_MID: Color = Color("#ff9900")
const COLOR_GOOD: Color = Color("#33cc33")

func _ready() -> void:
	# set_health(start_health)
	health = start_health

func set_color() -> void:
	if (health_bar.value < level_low):
		health_bar.tint_progress = COLOR_DANGER
	elif (health_bar.value < level_med):
		health_bar.tint_progress = COLOR_MID
	else:
		health_bar.tint_progress = COLOR_GOOD

func update_health_bar():
	health_bar.value = health
	update_label_health()

func update_max_health_bar():
	health_bar.max_value = max_health
	update_label_health()

func update_label_health():
	label_health.text = "%s/%s" % [health, max_health]

func take_damage(amount: float):
	#print_debug("take_damage: ", amount)
	# set_health(health - amount)
	health -= amount
	set_color()
	if (health <= 0): died.emit()
	
func increase_max_HP(_amount: float):
	pass
