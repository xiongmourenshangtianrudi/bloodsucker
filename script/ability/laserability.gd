extends Node2D
class_name laserability
signal re_to_pool(laser)
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $RayCast2D/Line2D
@onready var gpu_particles_2d: GPUParticles2D = $RayCast2D/startpos
@onready var endpos: GPUParticles2D = $RayCast2D/endpos
@onready var center: GPUParticles2D = $RayCast2D/center
var lineTarget:Vector2
@export var target_direction:Vector2
@onready var timer: Timer = $Timer
@export var timer_keep:float =0 ##持续时间 
@export var damage = 50
@export var offset_deg:int = 0
@onready var collision_shape_2d: CollisionShape2D = $hitBoxComponent/CollisionShape2D
@onready var hit_box_component: hitBoxComponent = $hitBoxComponent

var laserLenth = 250
var tween:Tween
# Called when the node enters the scene tree for the first time.


#func _ready() -> void:
	#segment_shape = SegmentShape2D.new()
	#segment_shape.a = Vector2(0,0)
	#segment_shape.b = ray_cast_2d.target_position
	#collision_shape_2d.shape = segment_shape ##更新进去
	
func start() -> void:
	
	appear()
	ray_cast_2d.enabled = true
	ray_cast_2d.target_position = target_direction*laserLenth
	lineTarget = ray_cast_2d.target_position
	collision_shape_2d.shape.b = lineTarget
	hit_box_component.monitoring = true
	hit_box_component.monitorable = true
	self.set_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: ##物理帧调用
	var cast_point = Vector2.INF
	var player =  get_tree().get_first_node_in_group("player")
	if player!=null:
		self.global_position = get_tree().get_first_node_in_group("player").global_position ##多人游戏时获取当前权威节点的玩家
		
		var dir = (get_mouse_pos() - global_position).normalized()
		target_direction = dir.rotated(deg_to_rad(offset_deg))
		
		ray_cast_2d.target_position = target_direction*laserLenth
		line_2d.points[0] = ray_cast_2d.position
		if ray_cast_2d.is_colliding():
			
			line_2d.points[1] = line_2d.to_local(ray_cast_2d.get_collision_point())
			cast_point = line_2d.to_local(ray_cast_2d.get_collision_point())
			collision_shape_2d.shape.b = line_2d.points[1]
			endpos.emitting = true
			var collider = ray_cast_2d.get_collider()
			#if collider != null && collider.is_in_group("enemy") :
					#collider._take_damage(damage*delta)
				###每秒检测
		else:
			line_2d.points[1] = ray_cast_2d.target_position
			cast_point = ray_cast_2d.target_position
			collision_shape_2d.shape.b = line_2d.points[1]
			
			endpos.emitting = false
			
			##计算粒子发射方向 
		var CalcDir= (line_2d.points[1] - line_2d.points[0]).normalized()
		var dirParticDir:Vector3 = Vector3(CalcDir.x,CalcDir.y,0)
		gpu_particles_2d.process_material.direction = dirParticDir
		
		center.position= cast_point * 0.5
		var cast_nor = cast_point.normalized()
		var dot = cast_nor.dot(ray_cast_2d.transform.x)
		var angle = acos(dot)
		if target_direction.y < 0 :
			angle = -angle 
		center.rotation = angle  ##计算两个向量的夹角
		
		center.process_material.emission_box_extents.x = cast_point.length() *0.5
		center.emitting = true
		endpos.position = line_2d.points[1] #获得激光中点的全局坐标
		
		endpos.process_material.direction = -dirParticDir
		
	


func control_particle():
	pass

func draw_laser(percent:Vector2)->void:
	print(percent)
	line_2d.points[1] = percent

func appear():
	tween = create_tween()
	tween.tween_property(line_2d,"width",8,0.5)
	timer.start(timer_keep)
	
func disapear():
	tween = create_tween()
	tween.tween_property(line_2d,"width",0,0.1)
	
	
	
	
##获得鼠标坐标

func get_mouse_pos()->Vector2:
	return get_viewport().get_camera_2d().get_global_mouse_position()


func _on_timer_timeout() -> void:
	disapear()
	tween.finished.connect(destroy_self)
	
	pass # Replace with function body.


func destroy_self():
	print("回收")
	ray_cast_2d.enabled = false
	gpu_particles_2d.emitting = false
	endpos.emitting = false
	center.emitting = false
	hit_box_component.monitoring = false
	hit_box_component.monitorable = false
	re_to_pool.emit(self)
