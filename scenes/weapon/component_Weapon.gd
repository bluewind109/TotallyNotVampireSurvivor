extends Node
class_name ComponentWeapon

var weapon_data: WeaponData

var damage: float
var attack_speed: float
var attack_type: WeaponConfig.ATTACK_TYPE

var gun_type: WeaponConfig.GUN_TYPE
var projectile_speed: float

@export var attack_timer: Timer
var is_attack_ready: bool = true

var reload_timer: Timer

var weapon_dict: Dictionary = WeaponConfig.WEAPON_DICT

@export var reload_bar: TextureProgressBar

func _ready() -> void:
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	reload_timer.autostart = false
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	self.add_child(reload_timer)
	load_weapon_data(WeaponConfig.WEAPON_ID.AssaultRifle)
	reload_bar.hide()

func load_weapon_data(weapon_idx: String):

	if (not weapon_idx): 
		push_error("[component_Weapon] no index found")
		return

	if (not WeaponConfig.is_weapon_dict_key_exist(weapon_idx)):
		push_error("[component_Weapon] no value found")
		return

	var _data = load(weapon_dict[weapon_idx])
	print("[component_Weapon] load_weapon_data: ", _data.get_res_name())
	weapon_data = _data
	weapon_data.init_data()
	is_attack_ready = true

func _process(_delta: float) -> void:
	if (!reload_timer.is_stopped()):
		var progress_val = (reload_timer.time_left / reload_timer.wait_time) * 100
		# SignalManager.ui_on_reload.emit(progress_val)
		update_reload_bar(progress_val)

func update_reload_bar(val: float):
	# print("update_reload_bar ", val)
	reload_bar.value = 100 - val

func attack(_player: Player):
	if (not weapon_data): return

	match(weapon_data.attack_type):
		WeaponConfig.ATTACK_TYPE.Melee:
			return
		WeaponConfig.ATTACK_TYPE.Ranged:
			do_ranged_attack(_player)
			return
		_:
			return

func do_ranged_attack(_player: Player):
	# out of ammo
	if (weapon_data.current_ammo == 0): 
		# TODO play out of ammo sound
		# reload
		if (reload_timer.is_stopped()):
			reload()
			return
		return

	# firerate check
	if (!is_attack_ready): return
	is_attack_ready = false
	attack_timer.start(weapon_data.attack_speed)

	var projectile = weapon_data.projectile_node.instantiate() as Projectile

		## Apply upgrade before spawn bullet
	# print("shoot: ", player.upgrades.size())
	# for strategy in player.upgrades:
	# 	projectile = strategy.apply_upgrade(projectile)

	weapon_data.current_ammo -= 1
	# TODO use weapon's projectile speed var
	projectile.init_projectile(
		_player.position,
		get_parent().global_position.direction_to(get_parent().get_global_mouse_position()),
		_player.projectile_speed,
		_player.damage,
		_player.knockback_strength,
		_player.piercing_strenth
	)
	get_tree().current_scene.add_child(projectile)

func reload():
	if (not weapon_data): return
	print("reload")
	reload_timer.start(weapon_data.reload_time)
	reload_bar.show()

func _on_attack_timer_timeout():
	is_attack_ready = true

func _on_reload_timer_timeout() -> void:
	weapon_data.current_ammo = weapon_data.max_ammo
	reload_bar.hide()
	print("reload done")
