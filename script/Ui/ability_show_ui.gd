extends TextureRect
class_name ability_show_card
@export var ability_icon:Texture
@export var level:int
@export var ability_name:String

@onready var level_show: Label = $level_show
@onready var icon: ColorRect = $icon

var ability_id:String
##生成展示

func set_ability(currentAbility:AbilityUpgrade,upgreads:Dictionary):
	ability_id = currentAbility.id
	level = upgreads[currentAbility.id]["quantity"]
	ability_name = currentAbility.name
	ability_icon = currentAbility.icon
	update_ui()
		


func update_ui():
	level_show.text =str(level) 
	self.texture = ability_icon
	
	pass
