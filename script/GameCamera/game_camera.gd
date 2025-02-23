extends Camera2D

var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_node = get_tree().get_nodes_in_group("player");
	if  len(player_node)>0:
		var player = player_node[0] as Node2D
		target_position = player.global_position;
	
	global_position =global_position.lerp(target_position,1.0 - exp(-delta*20)) #这里用作缓动
