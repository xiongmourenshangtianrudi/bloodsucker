extends Node2D

@export var boom_particles:PackedScene
@export var speed:float #移动速度
@export var rotate_speed:float #转向速度
@onready var hit_box_component: hitBoxComponent = $hitBoxComponent

@export var max_move_distance = 300

@export var move_distance = 0


var current_dir:Vector2
var target_dir:Vector2

var target_our:Node2D
var target_our_position:Vector2

var is_move = true
var is_clockwise = true #是否顺时针

var target_angle:float
var angle_erro:float

var forground:Node2D


func _ready() -> void:
	forground = get_tree().get_first_node_in_group("forground")
	hit_box_component.area_entered.connect(_expolsion)
	pass # Replace with function body.


func set_target(target:Node):
	target_our = target






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_our !=null:
		target_our_position = target_our.global_position
	_rotate_move(delta)
	
	
	
	
func _rotate_move(delta:float):
	if !is_move:
		return
	
	global_position+=current_dir* speed*delta
	target_dir = (target_our_position - self.global_position).normalized()
	current_dir = Vector2.UP.rotated(rotation)
	var deviation = delta*10
	angle_erro = rad_to_deg(current_dir.angle_to(target_dir)) #计算角度误差
	if angle_erro > deviation:
		rotation_degrees+=rotate_speed*delta
	elif angle_erro < -deviation:
		rotation_degrees-=rotate_speed*delta
		
	move_distance+=delta*speed
	#print("move_distance",move_distance)
	if move_distance >=max_move_distance:
		_expolsion_null()
	
	
	
func _expolsion(area:Area2D):

	if area.get_parent().is_in_group("enemy"):
		##爆炸特效
		is_move = false
		##销毁自身
		var expolosion =boom_particles.instantiate()
		forground.add_child(expolosion)
		expolosion.global_position = self.global_position
		queue_free()
	

func _expolsion_null():
	is_move= false
	var expolosion =boom_particles.instantiate()
	forground.add_child(expolosion)
	expolosion.global_position = self.global_position
	queue_free()

	
