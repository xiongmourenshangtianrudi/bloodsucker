extends PanelContainer

@onready var name_label: Label = %nameLabel
@onready var description: Label = %description
@onready var card_animation: AnimationPlayer = $cardAnimation
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_num_text: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/progress_num_text
@onready var pur_chase_button: Button = %PurChaseButton
@onready var level_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/levelLabel



var upgrade:meta_upgrade


func _ready() -> void:
	pur_chase_button.pressed.connect(on_pressed_purchase)
	
	
	#gui_input.connect(_on_gui_click)


	

func set_meta_upgrade(upgrade:meta_upgrade):#显示升级的属性
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description.text = upgrade.description


func _on_gui_click(event:InputEvent):
	
	if event.is_action_pressed("left_click"):
		selected_card()
	
	
	

func selected_card():
	card_animation.play("selected")
	var cards = get_tree().get_nodes_in_group("upgrade_card")
	

func update_progress():
	var current_quantity = 0
	if MetaPrograssionManager.save_data["meta_upgrades"].has(upgrade.id):
		print("current_quantity",current_quantity)
		current_quantity = MetaPrograssionManager.save_data["meta_upgrades"][upgrade.id]["quantity"]
	var ismax:bool = current_quantity >= upgrade.max_quantity
	print(ismax)
	var persent = \
	MetaPrograssionManager.save_data["meta_upgrade_currency"] /upgrade.experence_coast
	persent = clampf(persent,0,1)
	progress_bar.value = persent
	progress_num_text.text = str(MetaPrograssionManager.save_data["meta_upgrade_currency"])+"/"+str(upgrade.experence_coast)
	pur_chase_button.disabled  = persent <1 ||ismax
	if ismax:
		pur_chase_button.text = "已经最等级"
	else:
		pur_chase_button.text = "购买"
	level_label.text = "x%d" % current_quantity

func on_pressed_purchase():
	if upgrade ==null:
		return

	MetaPrograssionManager.add_meta_upgrades(upgrade)##升级能力
	get_tree().call_group("meta_upgrade_card","update_progress")
	card_animation.play("selected")
