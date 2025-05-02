extends Resource
class_name WeaponData

@export var damage: float
func get_damage(is_base: bool = false):
	if (is_base):
		return damage
	else:
		return damage + damage * damage_multiplier

var damage_multiplier: float = 0.0
func add_damage_multiplier(val):
	damage_multiplier += val

## Number of attack per second => cooldown = 1 second / firerate
@export var attack_speed: float 
func get_attack_speed(is_base: bool = false):
	if (is_base):
		return attack_speed
	else:
		return attack_speed + attack_speed * attack_speed_multiplier

var attack_speed_multiplier: float = 0
func add_attack_speed_multiplier(val):
	attack_speed_multiplier += val

func get_attack_speed_by_time():
	return 1 / (attack_speed + attack_speed * attack_speed_multiplier)

@export var attack_type: WeaponConfig.ATTACK_TYPE
@export var attack_range: float
func get_attack_range(is_base: bool = false):
	if (is_base):
		return attack_range
	else:
		return attack_range + attack_range * attack_range_multiplier

var attack_range_multiplier: float = 0
func set_attack_range_multiplier(val):
	attack_range_multiplier += val

@export var knockback_strength: float = 20.0
func get_knockback_strength(is_base: bool = false):
	if (is_base):
		return knockback_strength
	else:
		return knockback_strength + knockback_strength * knockback_strength_multiplier

var knockback_strength_multiplier: float = 0
func add_knockback_strength_multiplier(val):
	knockback_strength_multiplier += val


func get_res_name() -> String:
	return resource_path.trim_suffix(".tres")

func attack(_player: Player, _direction: Vector2):
	return

var stat_dict: Dictionary[String, Variant] 
func get_all_stat() -> void:
	stat_dict = {
		"Damage": get_damage(),
		"AttackSpeed": get_attack_speed(),
		"AttackRange": get_attack_range(),
		"KnockbackStrength": get_knockback_strength(),
	}
	