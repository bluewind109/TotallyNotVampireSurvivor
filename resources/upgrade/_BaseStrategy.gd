extends Resource
class_name BaseStrategy

@export var rarity_multiplier = {
	UpgradeConfig.RARITY_ID.Common: 1.0,
	UpgradeConfig.RARITY_ID.Uncommon: 1.1,
	UpgradeConfig.RARITY_ID.Rare: 1.4,
	UpgradeConfig.RARITY_ID.Epic: 1.75,
	UpgradeConfig.RARITY_ID.Legendary: 2.0
}
func get_rarity_multiplier() -> float:
	return rarity_multiplier.get(rarity, 1.0)

var rarity: String
func set_rarity(val: String):
	rarity = val

func apply_upgrade(_player: Player):
	pass
