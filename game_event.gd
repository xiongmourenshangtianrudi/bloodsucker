extends Node

signal emit_experence_vial_collect(number:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrade:Dictionary)
signal player_died()
signal player_damage 
signal game_over ##游戏结束信号
signal spawn_boss
signal update_boss_state(boss_info,boss_max_health:int,boss_corrent_health:int)
signal update_player_state(player_current_health:float)


func _ready() -> void:
	#var mouse_pos = preload("res://assets/Resource/theme/mouse_dot/IconamoonCursorDuotone.png")
	#Input.set_custom_mouse_cursor(mouse_pos)
	pass
func emit_experence_vial_collected(number:float):##收集经验值
	emit_experence_vial_collect.emit(number)
	

func emit_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrade:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrade)


func emit_player_damage():
	player_damage.emit()

func emit_update_player_state(player_health:float)->void: #更新玩家生命值ui
	update_player_state.emit(player_health)
