extends CanvasLayer

@onready var continueGameButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/continueGameButton
@onready var quit_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/quitButton
@onready var label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label
@onready var label_2: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label2

@onready var panel_container: PanelContainer = %PanelContainer
var tween :Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MetaPrograssionManager.save_file()
	panel_container.pivot_offset = panel_container.size/2
	panel_container.scale = Vector2.ZERO
	tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.tween_property(panel_container,"scale",Vector2.ONE,.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	get_tree().paused = true
	continueGameButton.pressed.connect(on_continue_game_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)



func _set_defeat():
	label.text = "defeat"
	label_2.text = "你死了"
	$defeatSound.play()
	
	
func _set_vectory():
	label.text = "vector"
	label_2.text = "你赢了"
	$victorySound.play()
func on_continue_game_button_pressed():##重新开始游戏
	#TODO 这里后期可以切换为新游戏场景，选择角色或者管卡
	#进入升级界面
	get_tree().paused = false
	ScreenTransition.change_to_scene("res://scene/UI/metaMenu.tscn")
	pass
	
func on_quit_button_pressed():
	get_tree().paused = false
	ScreenTransition.change_to_scene("res://scene/UI/main_menu.tscn")
	pass
