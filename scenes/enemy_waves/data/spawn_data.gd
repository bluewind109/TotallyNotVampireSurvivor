extends Resource

class_name SpawnData

## Data of the enemies of this wave.
# @export var waves: Array[EnemyType]
@export var waves: Dictionary[SpawnConfig.ENEMY_TYPE, EnemyType]

## Time between each spawn (time random between X and Y) (seconds).
@export var spawn_interval: Vector2 = Vector2(2.0, 3.0)

## How many enemies spawn per tick.
@export var spawns_per_tick: Vector2i = Vector2i(1, 1)

## How long the wave will last (seconds).
@export var duration: float = 60.0

## Get enemy type to spawn.
## Optional param: total_enemies -> total enemies on the screen atm
func get_spawns(_total_enemies: int) -> Array[EnemyType]:
	var count = randi_range(spawns_per_tick.x, spawns_per_tick.y)

	var result: Array[EnemyType] = []
	for i in range(0, count, 1):
		result[i] = waves.values()[randi_range(0, waves.size())]

	return result

## Get a random spawn interval between min and max values.
func get_spawn_interval() -> float:
	return randf_range(spawn_interval.x, spawn_interval.y)
