extends Node2D
var MAX_RADIUS = 100

@onready var hit_box_component: hitBoxComponent = $hitBoxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#var dir:Vector2 = Vector2.ZERO
var base_dir = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	base_dir = Vector2.RIGHT.rotated(randf_range(0,TAU))
	#hit_box_component.area_entered
	animation_player.play("rotate")
	var tween = create_tween()
	tween.tween_method(tween_method,0.0,2.0,3).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)

func tween_method(rotations:float):
	var persent = rotations / 2
	var current_radius = persent *MAX_RADIUS
	
	var current_direction = base_dir.rotated(rotations*TAU)
	
	
	#TODO 后面改成多人游戏时，需要吧定位信息改一下 改成获取当前主机的player
	#当前对象的位置
	var root_position = Vector2.ZERO
	##获取角色的位置
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	root_position = player.global_position ##
	
	global_position = root_position+ (current_direction * current_radius)
 
