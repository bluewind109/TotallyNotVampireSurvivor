extends Resource
class_name Weapon

@export var title: String
@export var texture: Texture2D

# properties for projectile
@export var damage: float
@export var cooldown: float
@export var speed: float

@export var projectile_node: PackedScene = preload("res://scenes/projectile/projectile.tscn")

@export var upgrades: Array[ProjectileUpgrade]
var level = 1

func activate(_source, _target, _scene_tree):
	pass

func is_upgradable() -> bool:
	if (level <=  upgrades.size()):
		return true
	return false

func upgrade_item():
	if (not is_upgradable()): return
	
	var upgrade = upgrades[level - 1]
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	speed += upgrade.speed
	level += 1
