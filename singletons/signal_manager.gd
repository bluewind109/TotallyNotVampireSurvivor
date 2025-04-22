extends Node

signal on_level_up
signal on_pickup(xp_amount: float)
signal on_player_hit(damage: float)
signal on_upgrade_selected(strategy: BaseProjectileStrategy)

signal on_show_wave_number(wave_num: int)
signal on_enemy_dead
