extends Node

@export_range(0,1) var drop_percent:float = 0

@export var viad_scene:PackedScene
@export var healthcomponent:Node



func _ready() -> void:
	(healthcomponent as health_component).died.connect(on_died)
	
	
func on_died():
	var adjust_drop_percent = drop_percent
	var experence_gain_upgrade_count= MetaPrograssionManager.get_meta_upgrade_count("experence_gain")
	adjust_drop_percent +=experence_gain_upgrade_count
	if randf() <=adjust_drop_percent:
		if viad_scene == null:
			return
			
		if not owner is Node2D:
			return 
		
		var Entitly = get_tree().get_first_node_in_group("Entitly")
		var instance:Node2D =viad_scene.instantiate() as Node2D
		Entitly.add_child(instance)
		
		instance.global_position = self.get_parent().position
	
