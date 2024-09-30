extends Area2D
class_name BasePickup

@onready var sprite_2d: Sprite2D = $Sprite2D

var direction: Vector2
var speed: float = 175.0

@export var type: Pickups
@export var player_ref: CharacterBody2D:
	set(value):
		player_ref = value
		type.player_ref = value

var can_follow: bool = false

func _ready() -> void:
	sprite_2d.texture = type.icon

func _physics_process(delta: float) -> void:
	if (player_ref and can_follow):
		direction = (player_ref.position - position).normalized()
		position += direction * speed * delta

func follow(_target: CharacterBody2D):
	#print("follow")
	can_follow = true

func _on_body_entered(body: Node2D) -> void:
	type.activate()
	queue_free()
