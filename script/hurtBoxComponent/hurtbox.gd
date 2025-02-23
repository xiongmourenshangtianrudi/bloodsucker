extends Area2D
class_name hurtbox
signal hit
@export var helathbox:health_component
var floating_text = preload("res://scene/UI/floating_text.tscn") ##加载场景
var current_duaring = 0
var forginground:Node2D
var persistent_array:Array
func _ready() -> void:
	forginground = get_tree().get_first_node_in_group("forground")as Node2D
	area_entered.connect(_on_area_2d_area_entered)


func _physics_process(delta: float) -> void:
	if current_duaring<=1:
		current_duaring +=delta
	
	if persistent_array .size()>0:
		calc_persitent_damage(delta)##计算伤害值


func calc_persitent_damage(delta:float):
	var damage_count = 0 #统计伤害
	
	
	for i in persistent_array: ##计算持续伤害
		helathbox.damage(i.damage*delta)      
		damage_count +=i.damage*delta
		
		
	if current_duaring >=1:
		var f_t = floating_text.instantiate() #实例化
		forginground.add_child(f_t)
		f_t.global_position = self.global_position
		f_t.start(str(round(damage_count*10)/10))
		damage_count = 0
		current_duaring=0
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not area is hitBoxComponent:
		return
	if helathbox ==null:
		return
	##计算持续伤害
	if area.get_parent().is_in_group("persistent_damage"):
		persistent_array.append(area) ##把这个对象加进去进行持续伤害
		return
	
	var hitbox_component = area as hitBoxComponent		
	helathbox.damage(hitbox_component.damage)
	var f_t = floating_text.instantiate() #实例化
	f_t.global_position = self.global_position
	forginground.add_child(f_t)
	f_t.start(str(round(hitbox_component.damage*10)/10 ))
	hit.emit()


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("persistent_damage"):
		print("移除出去")
		persistent_array.erase(area) ##把这个对象移除出去
		return
