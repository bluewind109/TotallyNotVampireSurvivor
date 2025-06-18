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
# @export var must_kill_all: bool = false

var spawnRng = RandomNumberGenerator.new()
func get_random_enemy_type() -> SpawnConfig.ENEMY_TYPE:
	var weighted_sum = 0
	for enemy_type in waves:
		weighted_sum += waves[enemy_type].spawn_weight
	
	var weight_result: float = spawnRng.randf_range(0.0, weighted_sum)

	for enemy_type in waves:
		if (weight_result < waves[enemy_type].spawn_weight):
			return enemy_type
		weight_result -= waves[enemy_type].spawn_weight

	return SpawnConfig.ENEMY_TYPE.Cube

func get_spawns(total_enemies: int) -> Array[EnemyType]:
	# print("[wave_data] get_spawns total_enemies: ", total_enemies)
	var result: Array[EnemyType] = []
	if (spawn_count >= total_spawns):
		print("[wave_data] get_spawns max spawn reached ")
		return result

	## Determine how many enemies will be spawned.
	var count: int = randi_range(spawns_per_tick.x, spawns_per_tick.y)
	count = mini(min_spawn_count, count)

	## If current number of enemies on screen is less that minimum count
	## We will spawn that amount to fill it
	if (total_enemies + count < min_spawn_count):
		count = min_spawn_count - total_enemies

	# Get enemy type to spawn, based on spawn weight in wave data
	var type_to_spawn: = get_random_enemy_type()
	## Generate enemies that will be spawned.
	for i in range(0, count, 1):
		## Randomize
		result.append(waves[type_to_spawn])

	spawn_count += count
	# print("[wave_data] get_spawns spawn_count: %s - count: %s" % [spawn_count, count])
	return result
