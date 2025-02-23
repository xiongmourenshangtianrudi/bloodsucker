extends CanvasLayer
@onready var animation: AnimationPlayer = $Animation
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var option: Button = %option
@onready var quit_menu: Button = %quit_menu
@onready var re_sunme: Button = %re_sunme
var option_scene = preload("res://scene/UI/optionsMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	re_sunme.pressed.connect(_re_sume)
	option.pressed.connect(_on_option)
	quit_menu.pressed.connect(_quit_main_menu)
	
	animation.play("showPasul")
	panel_container.pivot_offset = Vector2(panel_container.size.x/2,panel_container.size.y/2)
	var tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.tween_property(panel_container,"scale",Vector2.ONE,.3)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	
	pass # Replace with function body.



func _re_sume():
	var tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ONE,0)
	tween.tween_property(panel_container,"scale",Vector2.ZERO,.3)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	queue_free()
	get_tree().paused =false





func _on_option():
	var option = option_scene.instantiate()
	get_parent().add_child(option)
	option.back_pressed.connect(_close_option.bind(option))


func _close_option(option:Node):
	option.queue_free()


func _quit_main_menu():
	get_tree().paused =false
	MetaPrograssionManager.save_file()
	ScreenTransition.change_to_scene("res://scene/UI/main_menu.tscn")
