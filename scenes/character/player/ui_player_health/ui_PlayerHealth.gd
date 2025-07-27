extends TextureProgressBar
class_name ui_PlayerHealth

@export var label_health: Label

var level_low: float = 0.30
var level_med: float = 0.65
var start_health: float = 100.0

const COLOR_DANGER: Color = Color("#cc0000")
const COLOR_MID: Color = Color("#ff9900")
const COLOR_GOOD: Color = Color("#33cc33")

func _ready() -> void:
	pass

func set_color() -> void:
	if (self.value < level_low):
		self.tint_progress = COLOR_DANGER
	elif (self.value < level_med):
		self.tint_progress = COLOR_MID
	else:
		self.tint_progress = COLOR_GOOD

func update_health_bar(val: float):
	self.value = val
	update_label_health()

func update_max_health_bar(val: float):
	self.max_value = val
	update_label_health()

func update_label_health():
	label_health.text = "%s/%s" % [self.value, self.max_value]
