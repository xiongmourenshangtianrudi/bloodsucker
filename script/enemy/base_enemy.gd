extends CharacterBody2D

@export var speed:float = 75
@onready var health_componen: health_component = $HealthComponent
@onready var hurt: hurtbox = $hurtbox
@onready var health_bar: ProgressBar = $healthBar
@onready var random_stream_player_2d: AudioStreamPlayer2D = $RandomStreamPlayer2d
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
var target:Vector2


func _ready() -> void:
	health_componen.connect("died",_stop_move)
	health_componen.health_change.connect(update_healthBar)
	hurt.hit.connect(_play_sound_audo)
	update_healthBar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var dir = get_player_direction() ##移动
	#velocity = dir*speed
	#move_and_slide()
	move_to(get_player_pos())
	target = navigation_agent.get_next_path_position()
	if self.global_position.distance_to(target)>=5:
		# 角色朝着目标位置移动
		var direction = (target - self.global_position).normalized()
		velocity = direction*speed
		move_and_slide()
	

func move_to(target_pos:Vector2):
	navigation_agent.target_position = target_pos #给值
	
func get_player_pos():
	if get_tree().get_first_node_in_group("player")!=null:
		return get_tree().get_first_node_in_group("player").global_position
	else:
		return Vector2.ZERO
#func get_player_direction()->Vector2: ##获取玩家的方向
	#var player_node:Node2D = get_tree().get_first_node_in_group("player")as Node2D
	#if player_node != null:
		#if self.global_position.distance_to(player_node.global_position)>=5:##计算路径
			#
			#return (player_node.global_position - self.global_position).normalized()
	#return Vector2.ZERO
	
	
func _stop_move():
	self.remove_from_group("enemy")
	self.add_to_group("die")
	hurt.monitorable = false
	var sprite = self.get_child(6)as Node2D
	sprite.visible = false
	health_bar.visible = false
	set_process(false)
	pass


func _play_sound_audo():
	random_stream_player_2d.play_random()



func update_healthBar():
	var persent = health_componen.get_health_persent()
	health_bar.value = persent



func _take_damage(damage):
	health_componen.damage(damage)
	update_healthBar()
