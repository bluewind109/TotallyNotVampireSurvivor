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
	load_weapon_data(WeaponConfig.WEAPON_ID.Pistol)
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

	if (!reload_timer.is_stopped()):
		reload_timer.stop()
		reload_bar.hide()
		return

	# firerate check
	if (!is_attack_ready): return
	is_attack_ready = false
	attack_timer.start(weapon_data.attack_speed)

	## Apply upgrade before spawn bullet
	# print("shoot: ", player.upgrades.size())
	# for strategy in player.upgrades:
	# 	projectile = strategy.apply_upgrade(projectile)

	var _direction = get_parent().global_position.direction_to(get_parent().get_global_mouse_position())
	weapon_data.attack(_player, _direction)


func reload():
	if (not weapon_data): return
	if (not reload_timer.is_stopped()): return
	if (not weapon_data.can_reload()): return

	print("reload")
	reload_timer.start(weapon_data.reload_time)
	reload_bar.show()

func _on_attack_timer_timeout():
	is_attack_ready = true

func _on_reload_timer_timeout() -> void:
	print("reload done")
	weapon_data.reload()
	reload_bar.hide()
	if (weapon_data.can_reload()): reload()
