extends CanvasLayer


@export var experence_manager:experenceManager
@onready var progress_bar: ProgressBar = $MarginContainer/MarginContainer/VBoxContainer/ProgressBar
@export var abiliay_ui:PackedScene
@export var abilitys:Array[AbilityUpgrade]
@onready var ability_box: GridContainer = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/background/ability_box
@onready var health: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/health




func _ready() -> void:
	
	experence_manager.experence_update_collected.connect(update_progressBar)
	GameEvent.ability_upgrade_added.connect(update_ability_ui)
	GameEvent.update_player_state.connect(update_health)
func update_ability_ui(upgrade:AbilityUpgrade,upgrades:Dictionary):
	
	if !"other" in upgrade:
		for item in abilitys:
			if item.id == upgrade.id:
				for i in ability_box.get_children():
					if i.get_child(0).ability_id == upgrade.id:
						i.get_child(0).set_ability(upgrade,upgrades)
						return
			
		
		
		for i in ability_box.get_children():
			if i.get_child_count() ==0 :
				var ability_ui_info = abiliay_ui.instantiate()
				i.add_child(ability_ui_info)
				ability_ui_info.set_ability(upgrade,upgrades)
				abilitys.append(upgrade)
				break
			pass


func update_health(health_num:float)->void:
	health.text = str(floor(health_num))

func update_progressBar(current_experence:float,target_experence)->void :
	if target_experence== 0:
		return
		
	var persent:float = current_experence/target_experence #计算百分比
	progress_bar.value = persent
