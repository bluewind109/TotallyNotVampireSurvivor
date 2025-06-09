extends Node

class_name SpawnManager

@export var enemy_container: Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

## Player reference
@export var player_ref: CharacterBody2D

var cur_wave_index: int: ## Index of current wave
	set(val):
		cur_wave_index = val
		SignalManager.on_show_wave_number.emit(cur_wave_index)

var current_wave: WaveData

var cur_wave_spawn_count: int = 0 ## Tracks how many enemies have spawned
var cur_enemy_alive: int = 0 ## Tracks how many enemies still alive
# var cur_wave_duration: float = 0.0

@export var data: Array[WaveData]

var max_enemy_count: int = 700
var spawn_distance: float = 200.0

@export var list_enemy_type: Dictionary[SpawnConfig.ENEMY_TYPE, PackedScene]

var is_wave_kill_enabled: bool = false # PRIOR 1 condition
var is_wave_duration_enabled: bool = false # PRIOR 2 condition

func _ready() -> void:
	SignalManager.on_enemy_dead.connect(on_enemy_dead)
	init()

func init() -> void:
	cur_wave_index = 0
	set_new_wave.call_deferred(cur_wave_index)

func get_random_position() -> Vector2:
	return player_ref.global_position + spawn_distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

## check if wave has ended
func has_wave_ended() -> bool:
	if (cur_wave_index >= data.size()): return true # no more wave to spawn

	# If wave_duration is one of the Exit Conditions, 
	# check how long the wave has been running.
	# If cur_wave_duration is not greater than wave_duration, do not exit.
	if (!is_wave_duration_reached()):
		return false

	# If kill_reached is one of the Exit Conditions.
	if (!is_wave_kill_reached()):
		return false

	# If kill_all is enalbed, all enemies has to be defeated.
	if (current_wave.must_kill_all and cur_enemy_alive > 0): 
		return false

	return true

func set_new_wave(wave_index: int):
	current_wave = data[wave_index]
	is_wave_duration_enabled =\
		current_wave.exit_conditions == SpawnConfig.EXIT_CONDITION.Wave_Duration or\
		current_wave.exit_conditions == SpawnConfig.EXIT_CONDITION.Everything
	if (is_wave_duration_enabled):
		wave_timer.start(current_wave.duration)
	else:
		wave_timer.stop()

	is_wave_kill_enabled =\
		current_wave.exit_conditions == SpawnConfig.EXIT_CONDITION.Kill_Reached or\
		current_wave.exit_conditions == SpawnConfig.EXIT_CONDITION.Everything

func get_new_spawns() -> Array[EnemyType]:
	return data[cur_wave_index].get_spawns(cur_enemy_alive)

func is_wave_duration_reached() -> bool:
	return is_wave_duration_enabled and wave_timer.is_stopped()

func is_wave_kill_reached() -> bool:
	return is_wave_kill_enabled and cur_wave_spawn_count >= current_wave.total_spawns

func can_spawn() -> bool:
	if (cur_wave_index >= data.size()):
		return false
	if (has_exceeded_max_enemies()):
		return false
	if (cur_wave_spawn_count > data[cur_wave_index].total_spawns):
		return false
	return true

func has_exceeded_max_enemies() -> bool:
	if (cur_wave_spawn_count > max_enemy_count): return true
	return false

func on_enemy_dead(_drop) -> void:
	cur_enemy_alive -= 1
	cur_enemy_alive = maxi(0, cur_enemy_alive)
	return

func _on_spawn_timer_timeout() -> void:
	if (has_wave_ended()):
		## no more wave left to spawn
		if (cur_wave_index + 1 >= data.size()):
			print("no more wave to spawn")
			return

		## advance to next wave
		cur_wave_index += 1
		# cur_wave_duration = 0
		cur_wave_spawn_count = 0
		print("next wave: ", cur_wave_index)
		return

	if (!can_spawn()):
		spawn_timer.start(data[cur_wave_index].get_spawn_interval())
		return
	
	var spawns = get_new_spawns()
	spawn(spawns)

func spawn(spawns: Array[EnemyType]) -> void:
	# print("spawn new wave")
	for prefab in spawns:
		if (!can_spawn()): continue

		var enemy_instance: Enemy
		match prefab.type:
			SpawnConfig.ENEMY_TYPE.Cube:
				enemy_instance = list_enemy_type[SpawnConfig.ENEMY_TYPE.Cube].instantiate() as EnemyCube
			SpawnConfig.ENEMY_TYPE.Eye:
				enemy_instance = list_enemy_type[SpawnConfig.ENEMY_TYPE.Eye].instantiate() as EnemyEye
			SpawnConfig.ENEMY_TYPE.EyeGhost:
				enemy_instance = list_enemy_type[SpawnConfig.ENEMY_TYPE.EyeGhost].instantiate() as EnemyEyeGhost
			_:
				enemy_instance = list_enemy_type[0].instantiate() as Enemy
		cur_wave_spawn_count += 1
		cur_enemy_alive += 1
		enemy_instance.init_spawn(
			get_random_position(), 
			player_ref,
			prefab.rank,
		)
		# get_tree().current_scene.add_child.call_deferred(enemy_instance)
		enemy_container.add_child.call_deferred(enemy_instance)
		# SignalManager.on_enemy_spawn.emit(enemy_instance)

	spawn_timer.start(data[cur_wave_index].get_spawn_interval())


func _on_wave_timer_timeout() -> void:
	pass # Replace with function body.
