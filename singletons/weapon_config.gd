extends Node

const weapon_res_path = "res://scenes/weapon/gun/"

const WEAPON_ID = {
	"Pistol": "Pistol",
	"AssaultRifle": "AssaultRifle"
}

enum ATTACK_TYPE {
	Melee,
	Ranged
}

enum GUN_TYPE {
	Pistol,
	AssaultRifle
}

const WEAPON_DICT = {
	WEAPON_ID.Pistol: weapon_res_path + "weapon_Gun_Pistol.tres",
	WEAPON_ID.AssaultRifle: weapon_res_path + "weapon_Gun_AssaultRifle.tres"
}

func is_weapon_dict_key_exist(val: String) -> bool:
	return WEAPON_DICT.has(val)
