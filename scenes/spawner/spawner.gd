extends Node2D


@export var player: CharacterBody2D
@export var enemy: PackedScene

var distance: float = 400.0
var can_spawn: bool = true

@export var enemy_types: Array[EnemyType]

var minute: int:
	set(value):
		minute = value
		%Minute.text = str(value)

var second: int:
	set(value):
		second = value
		if (second >= 10): #60
			second -= 10 #60
			minute += 1
		%Second.text = str(value).lpad(2, '0')

func _physics_process(delta: float) -> void:
	# only spawn 700 mobs at MAX
	if get_tree().get_node_count_in_group("Enemy") < 700:
		can_spawn = true
	else:
		can_spawn = false

func spawn(pos: Vector2, elite: bool = false):
	if not can_spawn and not elite:
		return
	
	var enemy_instance = enemy.instantiate()
	
	# different wave of enemy each minute
	enemy_instance.type = enemy_types[
		min(minute, 
		enemy_types.size() - 1)
	]
	# set spawn position
	enemy_instance.position = pos
	enemy_instance.player_ref = player
	enemy_instance.elite = elite

	get_tree().current_scene.add_child(enemy_instance)	

# get random position from player at a certain distance
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

# spawn enemy with a certain amount
func amount(number: int = 1):
	for i in range(number):
		spawn(get_random_position())


func _on_spawn_timeout() -> void:
	second += 1
	amount(second % 10)


func _on_pattern_timeout() -> void:
	for i in range(75):
		spawn(get_random_position())


func _on_elite_timeout() -> void:
	spawn(get_random_position(), true)
