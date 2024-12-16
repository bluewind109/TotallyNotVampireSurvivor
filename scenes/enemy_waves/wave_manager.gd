extends Node

class_name WaveManager

@export var waves: Array[WaveList]
@export var player: CharacterBody2D
@export var enemy: PackedScene

var distance: float = 400.0
var can_spawn: bool = true
var current_wave: WaveList
var wave_num: int = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	update_subwave_amount()
	pass
	
func update_subwave_amount() -> void:
	current_wave.current_sub_wave
	
func get_next_wave() -> WaveList:
	var _wave: WaveList = waves[wave_num]
	
	wave_num += 1
	if (wave_num >= waves.size()):
		wave_num = 0
		
	return _wave
	
func spawn(pos: Vector2, elite: bool = false):
	if not can_spawn and not elite:
		return
	
	var enemy_instance = enemy.instantiate()
	


	# set spawn position
	enemy_instance.position = pos
	enemy_instance.player_ref = player
	#enemy_instance.elite = elite

	get_tree().current_scene.add_child(enemy_instance)	
	
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

# spawn enemy with a certain amount
func amount(number: int = 1):
	for i in range(number):
		spawn(get_random_position())
