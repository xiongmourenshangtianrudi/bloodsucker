extends Node
class_name SwardAbilityManager
@export var sward:PackedScene
@export var damage = 25
@export var MAX_DISTANCE:float = 150
var timer:Timer
var default_waitTimer:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	timer = get_node("Timer")
	default_waitTimer = timer.wait_time #获取默认冷却时间
	timer.timeout.connect(Callable(self,"timerOut"))
	meta_upgrade_update() ##开始游戏时更新元数据升级
	GameEvent.ability_upgrade_added.connect(upgrade_added)
	

func timerOut()->void: #这里后面要改
	var  player = get_tree().get_first_node_in_group("player")
	if player ==null:
		return
	
	var enemys = get_tree().get_nodes_in_group("enemy")
	enemys = enemys.filter(
	func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_DISTANCE,2)
		)
		
	if enemys.size() == 0:
		return
		
	enemys.sort_custom(
	func(a:Node2D,b:Node2D):
		var a_distance:float = a.global_position.distance_squared_to(player.global_position)
		var b_distance:float = b.global_position.distance_squared_to(player.global_position)
		return a_distance>b_distance
		)
	
	var swardInstance:Node2D = sward.instantiate() as Node2D
	swardInstance.get_child(2).damage = damage
	var forground = get_tree().get_first_node_in_group("forground")
	
	forground.add_child(swardInstance)
	
	swardInstance.global_position = enemys[0].global_position
	
	swardInstance.global_position +=Vector2.RIGHT.rotated(randf_range(0,TAU))*4
	var enemy_direction:Vector2 = enemys[0].global_position - swardInstance.global_position##方向向量
	swardInstance.rotation = enemy_direction.angle()
	
func meta_upgrade_update():
	self.damage =self.damage+ MetaPrograssionManager.get_meta_upgrade_count("sward_upgrade")*10
	
func upgrade_added(upgrade:AbilityUpgrade,current_upgrades: Dictionary):#用于升级这个能力的计算
	if upgrade.id !="sward_rate":
		return
	var percent_reduction = current_upgrades["sward_rate"]["quantity"]*0.1 #计算应该升级多少数值
	var time:float = default_waitTimer *(1- percent_reduction )#减少等待时间
	if time <= 0:
		timer.wait_time = 0.1
	else:
		timer.wait_time = time 
	timer.start()
	
	pass
	
