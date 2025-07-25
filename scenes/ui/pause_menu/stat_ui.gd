extends HBoxContainer
class_name StatUI

@export var label_stat_key: Label
@export var label_stat_value: Label

func set_data(stat_key: String, stat_value):
	if (stat_key == UpgradeConfig.UPGRADE_ID.MaxAmmo):
		stat_value = int(stat_value)
	elif (stat_key == UpgradeConfig.UPGRADE_ID.CritChance or 
		stat_key == UpgradeConfig.UPGRADE_ID.CritDmg):
		stat_value = str(stat_value * 100) + "%"
	label_stat_key.text = UpgradeConfig.UPGRADE_TEXT_DATA[stat_key]
	label_stat_value.text = str(stat_value)
