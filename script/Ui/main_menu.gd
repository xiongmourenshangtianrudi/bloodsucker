extends CanvasLayer
@onready var option: Button = %option
@onready var game_exit: Button = %gameExit
@onready var game_play: Button = %gamePlay
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var meta_upgrades: Button = %meta_upgrades

var option_scene = preload("res://scene/UI/optionsMenu.tscn")

func _ready() -> void:
	var tween = create_tween()
	panel_container.pivot_offset.x = panel_container.size.x/2
	panel_container.pivot_offset.y = panel_container.size.y/2

	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.tween_property(panel_container,"scale",Vector2.ONE,0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	game_play.pressed.connect(_on_play_game)
	game_exit.pressed.connect(_on_exit_game)
	option.pressed.connect(_on_option)
	meta_upgrades.pressed.connect(_on_upgrade_manu)


func _on_play_game():
	ScreenTransition.change_to_scene("res://scene/main/main.tscn")
	

func _on_upgrade_manu():
	ScreenTransition.change_to_scene("res://scene/UI/metaMenu.tscn")
	
	
func _on_exit_game():
	get_tree().quit()
	pass
	
	
func _on_option():
	var option_instance = option_scene.instantiate()
	add_child(option_instance)
	option_instance.back_pressed.connect(on_options_cloased.bind(option_instance))
	pass





func on_options_cloased(option_instance:Node):
	option_instance.queue_free()
	pass
