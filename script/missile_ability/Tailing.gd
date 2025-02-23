extends Line2D
@onready var weiba: Node2D = $"../weiba"

@export var max_dot_array = 100
var dot_array:Array[Vector2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dot_array.push_front(weiba.global_transform.origin)
	if (dot_array.size()>max_dot_array):
		dot_array.resize(max_dot_array)
	points = dot_array
