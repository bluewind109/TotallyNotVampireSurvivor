extends BaseItem

var LOOT_SPEED: float = 5.0

func _ready():
	item_type = "burger"
	super()

func _physics_process(delta):
	if (is_in_loot_range and can_be_loot):
		position +=\
		 (_player_ref.position - position).normalized() * LOOT_SPEED

## Add EXP to player on consumed
func consume() -> void:
	super()
