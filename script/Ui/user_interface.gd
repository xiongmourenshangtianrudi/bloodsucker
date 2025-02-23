extends CanvasLayer

@onready var label: Label = $MarginContainer/BoxContainer/Label

@onready var boss_name: Label = $MarginContainer/BoxContainer/boss_info_ui/bossName
@onready var boss_health_bar: ProgressBar = $MarginContainer/BoxContainer/boss_info_ui/BossHealthBar
@onready var boss_health: Label = $MarginContainer/BoxContainer/boss_info_ui/bossHealth
@onready var boss_info_ui: MarginContainer = $MarginContainer/BoxContainer/boss_info_ui

var timer_manager:Node
# Called when the node enters theaaa scene tree for the first time.
func _ready() -> void:
	GameEvent.spawn_boss.connect(show_boss_ui)
	GameEvent.update_boss_state.connect(flush_boss_ui)
	timer_manager = get_tree().current_scene.get_node("area_timer_manager")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = formate_timer_Style(timer_manager.get_time_elapsed())
	pass




func flush_boss_ui(boss_name_vir:String,bosshealth:int,boss_current_health:int):
	boss_name.text = boss_name_vir
	boss_health.text = str(boss_current_health)
	boss_health_bar.max_value = bosshealth
	boss_health_bar.value = boss_current_health
	
	pass

func show_boss_ui():
	boss_info_ui.show()


func formate_timer_Style(timer:float)->String:
	var minnd = floor(timer/60)
	var second = int(floor(timer)) % 60
	return str(minnd)+":"+str(second)
	
