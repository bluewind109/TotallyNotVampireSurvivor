extends Node

signal on_level_up
signal on_pickup(xp_amount: float)
signal on_player_hit(damage: float)
signal on_stat_upgrade_selected(strategy: BasePlayerStatStrategy)
signal on_buff_upgrade_selected # TODO

signal on_show_wave_number(wave_num: int)
signal on_enemy_dead

signal ui_on_reload(value: float)
signal ui_update_ammo_count(current_ammo: int, max_ammo: int)
