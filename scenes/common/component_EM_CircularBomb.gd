extends Node2D
class_name component_EM_CircularBomb

var player_ref: CharacterBody2D:
	get:
		player_ref = GameGlobal.player_ref
		return player_ref

var owner_ref: Enemy

@export var arc_projectile_node: PackedScene = preload("res://scenes/projectile/projectile_arc_Enemy.tscn")
@export var arc_projectile_timer: Timer

@export var projectile_damage: float = 5.0
var projectile_distance: float = 150
var projectile_angle: float = 60

var arc_spread: float = 360
var projectile_amount: int = 8

func _ready() -> void:
	return

func init(_ref: Enemy):
	owner_ref = _ref
	arc_projectile_timer.start.call_deferred()

func _on_arc_projectile_timer_timeout() -> void:
	shoot()

func shoot():
	if (owner_ref == null): return
	projectile_damage = owner_ref.get_damage() * 0.1

	arc_projectile_timer.start()
	for i in projectile_amount:
		var arc_projectile = arc_projectile_node.instantiate() as ProjectileArcEnemy

		var arc_rad = deg_to_rad(arc_spread)
		var increment = arc_rad / (projectile_amount - 1)
		var angle_from_direction = global_position.direction_to(player_ref.global_position).angle()
		var _rotation = angle_from_direction + increment * i - arc_rad / 2

		arc_projectile.launch_projectile(
			global_position,
			_rotation,
			# global_position.distance_to(player_ref.global_position),
			projectile_distance,
			projectile_angle,
			projectile_damage)
		get_tree().current_scene.add_child(arc_projectile)	
