extends VBoxContainer
class_name Options

@export var particle_level_up: GPUParticles2D
@export var panel_level_up: NinePatchRect

@export var weapons: HBoxContainer

var OptionSlot = preload("res://scenes/option_slot/option_slot.tscn")

func _ready() -> void:
	SignalManager.on_level_up.connect(show_option)
	
	hide()
	particle_level_up.hide()
	particle_level_up.emitting = false
	panel_level_up.hide()
	
func close_option():
	hide()
	particle_level_up.hide()
	particle_level_up.emitting = false
	panel_level_up.hide()
	get_tree().paused = false
	
func get_available_weapons():
	pass
	#var weapon_resource: Array[Weapon] = []
	#for weapon in weapons.get_children():
		#if (weapon.weapon != null):
			#weapon_resource.append(weapon.weapon)
		#return weapon_resource
	
func show_option():
	pass
	#var weapons_available = get_available_weapons()
	#if (weapons_available.size() == 0): return
	#
	#for slot in get_children():
		#slot.queue_free()
		#
	#var option_size = 0
	#for weapon in weapons_available:
		#if (!weapon.is_upgradable()): continue
		#
		#var option_slot = OptionSlot.instantiate()
		#option_slot.weapon = weapon
		#add_child(option_slot)
		#option_size += 1
	#
	## no more upgrade option
	#if (option_size == 0): return
	#
	#show()
	#particle_level_up.show()
	#particle_level_up.emitting = true
	#panel_level_up.show()
	#get_tree().paused = true
