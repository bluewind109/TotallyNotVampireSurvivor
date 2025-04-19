extends Resource
class_name EnemyType

@export var title: String
@export var type: SpawnConfig.ENEMY_TYPE = SpawnConfig.ENEMY_TYPE.Cube
@export var texture: Texture2D
@export var health: float
@export var damage: float
@export var speed: float = 50.0
@export var drops: Array[Pickups]
@export var is_elite: bool = false

func apply_elite_stat() -> void:
	return
