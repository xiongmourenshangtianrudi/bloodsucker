extends PanelContainer
signal selected

@onready var name_label: Label = %nameLabel
@onready var description: Label = %description
@onready var card_animation: AnimationPlayer = $cardAnimation
@onready var mouse_hover_animation: AnimationPlayer = $mouseHoverAnimation

var disable = false

func _ready() -> void:
	gui_input.connect(_on_gui_click)
	mouse_entered.connect(_on_mouse_hover)
	mouse_exited.connect(_on_mouse_leave)
func play_in(delay:float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	#modulate = Color.WHITE
	card_animation.play("showUpgradesCard")
	

func set_ability_upgrade(upgrade:AbilityUpgrade):#显示升级的属性
	print(upgrade.name)
	name_label.text = upgrade.name
	description.text = upgrade.description


func _on_gui_click(event:InputEvent):
	
	if disable: ##已经被点击的组件，将不可以触发事件
		return
	
	if event.is_action_pressed("left_click"):
		selected_card()
	
	
	

func selected_card():
	card_animation.play("selected")
	var cards = get_tree().get_nodes_in_group("upgrade_card")
	for other_card in cards:
		if other_card == self:
			continue
		other_card.disCard()
	
	
	disable = true
	await card_animation.animation_finished
	selected.emit()

func disCard():
	card_animation.play("disCard")


func _on_mouse_hover():
	if disable: ##已经被点击的组件，将不可以触发事件
		return
	mouse_hover_animation.play("mouseHover")
	
	
	
func _on_mouse_leave():
	if disable: ##已经被点击的组件，将不可以触发事件
		return
	mouse_hover_animation.play("mouseLeave")
