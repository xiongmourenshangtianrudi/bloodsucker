extends Node
class_name VelocityComponent
@export var move_speed= 125
@export var smooth_speed = 15
var acciption_in_direction:Vector2 = Vector2.ZERO

func set_acciption_in_direction(dir:Vector2 = Vector2.ZERO):
	acciption_in_direction = dir

func move(object:CharacterBody2D,delta:float):
	var speed = acciption_in_direction *move_speed
	object.velocity = object.velocity.lerp(speed,1-exp(-delta*smooth_speed))
	object.move_and_slide()
	pass
