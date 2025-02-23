extends Node
class_name missile_ability_manager
var MAX_DISTANCE = 400 ##获取最近的敌人
var max_mile_num = 1
@export var missile:PackedScene
@export var ability_cool = 3
@onready var timer: Timer = $Timer
@export var base_damage = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(ability_cool)
	print("这里是导弹系统")
	pass # Replace with function body.
	GameEvent.ability_upgrade_added.connect(upgrade_added)


func _on_timer_timeout() -> void:
	##时间到了，获取最近的敌人，并将其设置为目标
	print("发射导弹")
	var player = get_tree().get_first_node_in_group("player")
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
	
	for i in max_mile_num:	
		var missileInstance:Node2D = missile.instantiate() as Node2D
		var forground = get_tree().get_first_node_in_group("forground")
		missileInstance.global_position = player.global_position
		forground.add_child(missileInstance)
		missileInstance.hit_box_component.damage = base_damage
		if i<enemys.size():
			missileInstance.set_target(enemys[i])
			var rotate = calc_missile_dir(player.global_position,enemys[i].global_position).angle()##计算与x轴的夹角
			missileInstance.rotate(-rad_to_deg(90)+rotate)
			
		else:
			missileInstance.set_target(enemys[0])
	timer.start(ability_cool)
	pass # Replace with function body.




func calc_missile_dir(luncher_pos:Vector2,target_pos:Vector2):
	var dir = (target_pos - luncher_pos).normalized()
	return dir

func upgrade_added(upgrade:AbilityUpgrade,current_upgrades: Dictionary):#用于升级这个能力的计算
	if upgrade.id !="missile_rate":
		return
	base_damage +=current_upgrades[upgrade.id]["quantity"]*25
	max_mile_num = current_upgrades[upgrade.id]["quantity"]
	if current_upgrades[upgrade.id]["quantity"] == upgrade.maxlevel:
		base_damage = base_damage+1000
		
	
	pass
	
