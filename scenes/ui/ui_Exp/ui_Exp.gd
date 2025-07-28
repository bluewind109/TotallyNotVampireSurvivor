extends Control
class_name ui_Exp

@export var exp_bar: ProgressBar
@export var label_level: Label

func _ready() -> void:
	SignalManager.ui_update_exp_bar.connect(update_exp_bar)
	SignalManager.ui_update_level.connect(on_update_level)

func on_update_level(_level: int, required_exp: float):
	update_label_level(_level)
	exp_bar.max_value = required_exp

func update_label_level(_level: int):
	label_level.text = "Level %s" % str(_level)

func update_exp_bar(amount: float):
	exp_bar.value = amount
