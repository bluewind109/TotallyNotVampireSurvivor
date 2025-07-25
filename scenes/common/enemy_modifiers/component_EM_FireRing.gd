extends Node2D
class_name component_EM_FireRing

@export var sprite: Sprite2D
@export var anim_player: AnimationPlayer
@export var damage_cooldown_timer: Timer 

@export var damage: float = 5.0
@export var cooldown_duration: float = 0.25


var is_player_in: bool = false

func _ready() -> void:
	anim_player.play.call_deferred("fire_ring_spin")

func _physics_process(_delta: float) -> void:
	# if (damage_cooldown_timer.fini)
	if (not is_player_in):
		return
	
	if (damage_cooldown_timer.paused or damage_cooldown_timer.time_left == 0):
		SignalManager.on_player_hit.emit(damage)
		damage_cooldown_timer.start(cooldown_duration)

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group(GameGlobal.GROUP.PlayerHitbox)):
		is_player_in = true
		# print("is_player_in true")

func _on_area_exited(area: Area2D) -> void:
	if(area.is_in_group(GameGlobal.GROUP.PlayerHitbox)):
		is_player_in = false
		# print("is_player_in false")

func _on_damage_cooldown_timer_timeout() -> void:
	pass # Replace with function body.
