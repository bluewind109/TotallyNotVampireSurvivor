extends SpawnData

class_name WaveData

# @export var enemy_data: Array[EnemyType] # list of enemies that can spawn in this wave
# @export var enemy_type: EnemyType
# @export var amount: int = 1
# @export var isElite: bool = false
# @export var isBoss: bool = false


## If number of enemies less that this count, spawn more.
@export var min_spawn_count: int = 0

## How many enemies can spawn in this wave at maximum.
@export var total_spawns: int = 1

## What trigger the end of this wave (exit condition).
@export var exit_conditions: SpawnConfig.EXIT_CONDITION = SpawnConfig.EXIT_CONDITION.Wave_Duration

## All enemies must be dead for the wave to advance.
@export var must_kill_all: bool = false

## Number of enemies spawned in this wave.
var spawn_count: int

func get_spawns(total_enemies: int) -> Array[EnemyType]:
	## Determine how many enemies will be spawned.
	var count: int = randi_range(spawns_per_tick.x, spawns_per_tick.y)

	## If current number of enemies on screen is less that minimum count
	## We will spawn that amount to fill it
	if (total_enemies + count < min_spawn_count):
		count = min_spawn_count - total_enemies

	## Generate enemies that will be spawned.
	var result: Array[EnemyType] = []
	# print("get_spawns waves.size: ", waves.size())
	for i in range(0, count, 1):
		## Randomize
		result.append(waves[randi_range(0, waves.size() - 1)])

	return result
