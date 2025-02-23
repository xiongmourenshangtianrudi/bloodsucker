extends Node2D

signal spawn_boss

@export var enemy:Array[weightSource]
@onready var timer: Timer = $Timer
@export var enemySpawnTimer:Curve
@export var enemyHealth:Curve
@export var game_timer:Node

@export var enemy_damage_curve:Curve

@export var Boss:PackedScene
var enemy_damage:float
var spawned_boss = false
var spawn_range = 220
var weightedTabel:WeightedTable
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weightedTabel = WeightedTable.new()
	for i in enemy:
		weightedTabel.add_item(i.enemy,i.weight)
	timer.timeout.connect(spawnerEnemy)
	pass # Replace with function body.

func _process(delta: float) -> void:
	timer.wait_time = get_enemy_spawnTimer()
	enemy_damage = get_enemy_damage()
	
func get_spawn_positin():
	var player =get_tree().get_first_node_in_group("player") as Node2D #TODO 这里是获取场景中的玩家，如果有多个玩家如何解决
	if player ==null:
		return Vector2.ZERO
	
	var random_direction:Vector2 = Vector2.RIGHT.rotated(randf_range(0,TAU))##随机辐射方向
	for i in 4:
		var spawn_position = player.global_position+(random_direction*spawn_range)#旋转位置
		var query_ray = PhysicsRayQueryParameters2D.create(player.global_position,spawn_position,1 << 5)	#生成一个射线
		var re = get_tree().root.world_2d.direct_space_state.intersect_ray(query_ray)	
		#print(re)
		if re.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	return Vector2(566,271)
func spawnerEnemy(): ##生成敌人
	var player =get_tree().get_first_node_in_group("player") as Node2D #TODO 这里是获取场景中的玩家，如果有多个玩家如何解决
	if player ==null:
		return
	var enemy_instance= weightedTabel.pick_item().instantiate()
	enemy_instance.get_node("HealthComponent").max_health = get_enemy_health()
	
	var Entitly = get_tree().get_first_node_in_group("Entitly")
	Entitly.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_positin()
	weightedTabel.update_minWeight(game_process_ratio())
	
	if game_process_ratio()>=0.5 && !spawned_boss:
		var boss_instance = Boss.instantiate() as CharacterBody2D
		boss_instance.global_position = get_spawn_positin()
		Entitly.add_child(boss_instance)
		spawned_boss = true ##已经产生boss
		GameEvent.spawn_boss.emit()
		GameEvent.update_boss_state.emit("base_boss_test",boss_instance.get_child(0).max_health,boss_instance.get_child(0).current_health)
		##生成boss的警告，ui的产生等
		
		
		
		
func game_process_ratio()->float:
	return 1-(game_timer.get_child(0).time_left/game_timer.get_child(0).wait_time)

func get_enemy_health():
	return enemyHealth.sample(game_process_ratio())
func get_enemy_damage():
	return enemy_damage_curve.sample(game_process_ratio())
func get_enemy_spawnTimer():
	return enemySpawnTimer.sample(game_process_ratio())
