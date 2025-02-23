extends Node

@onready var timer: Timer = $Timer
@export var attack_range:float = 150
@export var attack_range_w:float = 24
@export var sprint_speed = 300
@export var range: PackedScene
var target_dir:Vector2
var current_sprint_distance = 0
var sprint = false
var is_action = false
var range_ins
func _ready() -> void:
	
	timer.timeout.connect(timer_out)

	
func _process(delta: float) -> void:
	if range_ins != null:
	##计算比率 剩余时间与总时间的比值
		var gap = timer.time_left / timer.wait_time
		range_ins.material.set_shader_parameter("gra",gap)
	
	
	if sprint && is_action:
		if current_sprint_distance <= attack_range:
			print("正在冲刺")
			owner.velocity = sprint_speed  *target_dir
			owner.move_and_slide()
			#print(owner.velocity)
			var dish_distance =  sprint_speed *delta *target_dir.length()
			current_sprint_distance += dish_distance
			#print(current_sprint_distance)
		else:
			sprint = false
			is_action = false
			current_sprint_distance = 0
			if range_ins !=null:
				range_ins.queue_free()
	pass
	
			

func skill_release():
	if is_action == true:
		range_ins= range.instantiate()
		var forgruond = get_tree().get_first_node_in_group("forground")
		forgruond.add_child(range_ins)
		range_ins.scale.x = attack_range/1024
		range_ins.scale.y = attack_range_w/512
		range_ins.global_position = owner.global_position
		var attack_target = get_tree().get_first_node_in_group("player")
		target_dir= (attack_target.global_position -  owner.global_position).normalized() 
		var cross_product = Vector2.RIGHT.x * target_dir.y - Vector2.RIGHT.y * target_dir.x ## right * dir  
		var angle = target_dir.angle_to(Vector2.RIGHT)
		if target_dir.y < owner.global_position.y: #right在dir 的顺时针方向，就表示
			angle = -angle
		range_ins.rotation = angle
		
		timer.start(2)
	pass

	
func timer_out():
	sprint = true
	range_ins.queue_free()
	pass
