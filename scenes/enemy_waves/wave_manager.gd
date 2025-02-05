extends Node

class_name WaveManager

@onready var spawn_timer: Timer = $SpawnTimer

@export var waves: Array[WaveList]
@export var player: CharacterBody2D
@export var enemy: PackedScene

var distance: float = 400.0
var can_spawn: bool = true
var current_WL: WaveList
var wave_num: int = 0

const SPAWN_AMOUNT: int = 10

func _ready() -> void:
	SignalManager.on_enemy_dead.connect(on_enemy_dead)
	call_deferred("set_current_WL")
	call_deferred("setup_next_spawn")
	spawn_timer.start()

func _process(delta: float) -> void:
	# only spawn 700 mobs at MAX
	if get_tree().get_node_count_in_group("Enemy") < 700:
		can_spawn = true
	else:
		can_spawn = false
		
	
func on_enemy_dead() -> void:
	#print_debug("[wave_manager] on_enemy_dead")
	return
	
func set_current_WL() -> void:
	print("[wave_manager] set_current_WL wave_num: ", wave_num)
	current_WL = waves[wave_num]
	current_WL.set_current_WD()
	
func get_next_WL() -> void:
	print("[wave_manager] get_next_WL")
	wave_num += 1
	if (wave_num >= waves.size()):
		wave_num = 0
	set_current_WL()
	SignalManager.on_show_wave_number.emit(wave_num)
	#print("[wave_manager] get_next_WL: ", _wave.resource_path)

func setup_next_spawn() -> void:
	#print("[wave_manager] setup_next_spawn")
	# get current wave data amount
	
	#if (current_WL.is_last_wd())
	var _wd_amount = current_WL.get_current_WD_amount()
	#print("[wave_manager] setup_next_spawn 1: ", _wd_amount)
	
	# no enemies left in this WD
	if (_wd_amount <= 0):
		if (current_WL.is_last_WD()):
			get_next_WL()
		else:
			current_WL.get_next_WD()
		
		## get next wd
		#var _current_wd = current_WL.get_next_WD()
		#
		## no wave data left in this wave list
		#if (_current_wd == null): 
			#get_next_WL()
			
		_wd_amount = current_WL.get_current_WD_amount()
		#print("[wave_manager] setup_next_spawn 2: ", _wd_amount)
		
	var _spawn_amount: int = SPAWN_AMOUNT
	if (_spawn_amount > _wd_amount): 
		_spawn_amount = _wd_amount
	spawn_multiple(_spawn_amount)
	current_WL.set_current_WD_amount(_spawn_amount)
	return
	
# spawn enemy with a certain amount
func spawn_multiple(number: int = 1):
	#print("[wave_manager] spawn_multiple: ", number)
	for i in range(number):
		spawn(get_random_position())
	
func spawn(pos: Vector2, elite: bool = false):
	if not can_spawn and not elite:
		return
	
	#print("[wave_manager] spawn")
	var enemy_instance = enemy.instantiate()

	enemy_instance.type = current_WL.get_current_enemy_type()

	# set spawn position
	enemy_instance.position = pos
	enemy_instance.player_ref = player
	#enemy_instance.elite = elite

	get_tree().current_scene.add_child(enemy_instance)
	
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func _on_spawn_timer_timeout() -> void:
	setup_next_spawn()
