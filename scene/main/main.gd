extends Node2D

var pausal_menu = preload("res://scene/UI/paused_menu.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausel"):
		var pasal = pausal_menu.instantiate()
		add_child(pasal)
	
