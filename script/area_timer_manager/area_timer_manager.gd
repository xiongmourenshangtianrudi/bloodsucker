extends Node
@export var end_screen_crene:PackedScene
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_timer_timerout)
	GameEvent.player_died.connect(_player_die)
	GameEvent.game_over.connect(game_end)#游戏结束


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func _timer_timerout():
	#var end_screen_crenes = end_screen_crene.instantiate()
	#add_child(end_screen_crenes)
	#end_screen_crenes._set_vectory()
	MetaPrograssionManager.save_file()
	##在场景中生成boss
	




func game_end():
	var end_screen_crenes = end_screen_crene.instantiate()
	add_child(end_screen_crenes)
	end_screen_crenes._set_vectory()
	MetaPrograssionManager.save_file()
func _player_die():
	var end_screen_crenes = end_screen_crene.instantiate()
	add_child(end_screen_crenes)
	end_screen_crenes._set_defeat()
	MetaPrograssionManager.save_file()
