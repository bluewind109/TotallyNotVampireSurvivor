extends EnemyModifier
class_name component_EM_IceRing

@export var sprite: Sprite2D
@export var anim_player: AnimationPlayer

@export var slow_ratio: float = 0.65
@export var slow_duration: float = 0.25

var is_player_in: bool = false

func _ready() -> void:
	anim_player.play.call_deferred("fire_ring_spin")

func activate():
	sprite.set_physics_process(true)
	sprite.visible = true
	anim_player.play.call_deferred("fire_ring_spin")

func _physics_process(_delta: float) -> void:
	if (not is_player_in):
		return
	
	SignalManager.on_player_slowed.emit(slow_ratio, slow_duration)

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group(GameGlobal.GROUP.PlayerHitbox)):
		is_player_in = true
		# print("is_player_in true")

func _on_area_exited(area: Area2D) -> void:
	if(area.is_in_group(GameGlobal.GROUP.PlayerHitbox)):
		is_player_in = false
		# print("is_player_in false")
