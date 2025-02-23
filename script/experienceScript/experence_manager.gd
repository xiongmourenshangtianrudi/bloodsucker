extends Node
class_name experenceManager
signal experence_update_collected(current_experence:float,target_experence:float)
signal level_up(new_level:int)

var current_experence = 0;
var current_level =1 
var target_experence = 5
const experence_target_growing = 5



func _ready() -> void:
	GameEvent.emit_experence_vial_collect.connect(on_experence_vial_collected)


func increment_experence_num(num:float): #用于增加经验值
	
	current_experence = min(current_experence+num,target_experence) 
	
	if current_experence >= target_experence:
		current_level += 1
		target_experence += experence_target_growing
		current_experence =0
		target_experence += experence_target_growing
		level_up.emit(current_level)
	experence_update_collected.emit(current_experence,target_experence)
	
func on_experence_vial_collected(num:float):
	increment_experence_num(num)
