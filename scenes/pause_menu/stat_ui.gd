extends HBoxContainer
class_name StatUI

@export var label_stat_key: Label
@export var label_stat_value: Label

func set_data(stat_key: String, stat_value):
	label_stat_key.text = UpgradeConfig.UPGRADE_TEXT_DATA[stat_key]
	label_stat_value.text = str(stat_value)
