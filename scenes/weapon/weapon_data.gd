extends Resource
class_name WeaponData

@export var damage: float
@export var attack_speed: float
@export var attack_type: WeaponConfig.ATTACK_TYPE
@export var attack_range: float

func get_res_name() -> String:
	return resource_path.trim_suffix(".tres")