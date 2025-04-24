extends BaseWeapon
class_name BaseGun

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile.tscn")
@onready var reload_timer: Timer = %ReloadTimer

## The time it takes to reload the gun
var reload_time: float = 2.0 # in seconds
func set_reload_time(val):
	reload_time = maxf(0.1, val)

var current_ammo: int:
	set(val):
		current_ammo = maxi(0, val)
		# update UI
		SignalManager.ui_update_ammo_count.emit(current_ammo, max_ammo)

var max_ammo: int:
	set(val):
		max_ammo = maxi(1, val)
		# update UI
		SignalManager.ui_update_ammo_count.emit(current_ammo, max_ammo)

func _process(_delta: float) -> void:
	if (!reload_timer.is_stopped()):
		var progress_val = (reload_timer.time_left / reload_timer.wait_time) * 100
		SignalManager.ui_on_reload.emit(progress_val)

func attack(player: Player):
	super(player)
	
	shoot(player)

func shoot(player: Player):
	# out of ammo
	if (current_ammo == 0): 
		# TODO play out of ammo sound
		# reload
		if (reload_timer.is_stopped()):
			reload()
			return
		return

	# firerate check
	if (!is_ready): return
	is_ready = false
	basic_attack_timer.start(player.base_attack_cooldown)

	var projectile = projectile_node.instantiate() as Projectile

	## Apply upgrade before spawn bullet
	# print("shoot: ", player.upgrades.size())
	# for strategy in player.upgrades:
	# 	projectile = strategy.apply_upgrade(projectile)

	current_ammo -= 1

	projectile.init_projectile(
		player.position,
		global_position.direction_to(get_global_mouse_position()),
		player.projectile_speed,
		player.damage,
		player.knockback_strength,
		player.piercing_strenth
	)
	get_tree().current_scene.add_child(projectile)

func reload():
	reload_timer.start(reload_time)

func _on_reload_timer_timeout() -> void:
	current_ammo = max_ammo
