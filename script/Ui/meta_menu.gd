extends CanvasLayer

@export var upgrades:Array[meta_upgrade] = [] ##保存可以升级的项目
@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %back_button

var meta_upgrade_card = preload("res://scene/UI/meta_upgrade_card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_back_to_manu)

	for i in grid_container.get_children():
		grid_container.remove_child(i)
		i.queue_free()
	#新建卡牌
	for upgrade in upgrades:
		var card = meta_upgrade_card.instantiate()
		grid_container.add_child(card)
		card.set_meta_upgrade(upgrade)
		card.update_progress()

func _back_to_manu():
	ScreenTransition.change_to_scene("res://scene/UI/main_menu.tscn")
