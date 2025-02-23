extends Sprite2D

class_name joyStick

var raduis = 70 
var onDrag = -1
@onready var sprite_2d: Sprite2D =$inner




func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag || (event is InputEventScreenTouch && event.is_pressed()):
		if event.position.distance_to(global_position)<=raduis || event.get_index()== onDrag:
			sprite_2d.global_position = event.position
			onDrag = event.get_index()
			if sprite_2d.global_position.distance_to(position) >= raduis:
				var dir:Vector2 = sprite_2d.global_position - position
				var normalizedVect = dir.normalized()
				sprite_2d.position = normalizedVect*raduis
				
	if event is InputEventScreenTouch && !event.is_pressed():
		if event.get_index() == onDrag:
			set_center()
			onDrag =-1


func set_center():
	sprite_2d.position = Vector2(0,0)


func get_now_pos(): ##放回方向响铃
	var dir:Vector2 = sprite_2d.global_position - position
	var normalizedVect = dir.normalized()
	print(normalizedVect)
	return normalizedVect 
