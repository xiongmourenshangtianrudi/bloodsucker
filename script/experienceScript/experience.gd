extends Node2D
var num = 5
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var player:playerControler = null



func tween_collect(percent:float,start_position:Vector2):
	if player == null:
		return
	global_position = start_position.lerp(player.global_position,percent)
	var direction_form_start = player.global_position - start_position
	var target_rotation = direction_form_start.angle() +deg_to_rad(90)
	rotation = lerp_angle(rotation,target_rotation,1-exp(-2*get_process_delta_time()))
	pass

func collect():
	GameEvent.emit_experence_vial_collected(num)
	
	queue_free()
	
func disable_collision():
	collision_shape_2d.disabled = true##禁用碰撞

func _on_area_2d_area_entered(area: Area2D) -> void:
	call_deferred("disable_collision")
	player = area.get_parent()
	var tween = create_tween()
	tween.set_parallel(true) ##将后续所有的tween设置为同时运行
	tween.tween_method(tween_collect.bind(global_position),0.0,1.0,0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite,"scale",Vector2.ZERO,.05).set_delay(.45)##设置延迟
	tween.chain()#将前面所有的tween完成后再执行后面的tween
	tween.tween_callback(collect)
	$RandomStreamPlayer2d.play_random()
	
	
	
