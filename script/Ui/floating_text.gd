extends Node2D
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass

func start(text:String):
	label.text = text
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"position",global_position+Vector2.UP *16,0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2.ONE,.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.chain()
	
	tween.tween_property(self,"position",global_position+Vector2.UP *48,.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2.ZERO,0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	

	tween.tween_callback(queue_free)

	var scale_tween = create_tween()
	scale_tween.tween_property(self,"scale",Vector2.ONE*1.3,.13).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	scale_tween.tween_property(self,"scale",Vector2.ONE,.13).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


	
	
	
