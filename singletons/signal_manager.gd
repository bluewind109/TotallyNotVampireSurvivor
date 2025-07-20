extends Node

signal on_level_up(level: int)
signal on_pickup(xp_amount: float)

signal on_player_hit(damage: float)
signal on_player_slowed(ratio: float, duration: float)

signal on_stat_upgrade_selected(strategy: BaseStrategy)
signal apply_stat(strategy: BaseStrategy)

signal on_buff_upgrade_selected # TODO

signal on_show_wave_number(wave_num: int)
signal on_enemy_dead(item: BasePickup)
signal on_enemy_spawn(enemy: Enemy)

signal ui_on_reload(value: float)
signal ui_update_ammo_count(current_ammo: int, max_ammo: int)

signal on_toggle_pause_menu(val: bool)
signal on_toggle_popup_levelup(val: bool)

signal ui_show_damage(position: Vector2, damage: float, is_crit: bool)

signal on_projectile_spawn(is_enemy_projectile: bool)	
