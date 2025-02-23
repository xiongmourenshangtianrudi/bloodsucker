extends Node
class_name axe_abilityControler
@export var aex_ability:PackedScene
@onready var cool_timer: Timer = $CoolTimer
var default_waitTimer:float
@export var damage = 10

func _ready() -> void:
	cool_timer.timeout.connect(_on_time_out)
	default_waitTimer = cool_timer.wait_time #获取默认冷却时间
	GameEvent.ability_upgrade_added.connect(upgrade_added)

func _on_time_out():
	var player = get_tree().get_first_node_in_group("player")
	if player ==null:
		return
	var forground = get_tree().get_first_node_in_group("forground")
	if forground == null:
		return
		
		
	var aex_instance = aex_ability.instantiate()as Node2D
	forground.add_child(aex_instance)
	aex_instance.hit_box_component.damage = damage
	aex_instance.global_position = player.global_position
	


func upgrade_added(upgrade:AbilityUpgrade,current_upgrades: Dictionary):#用于升级这个能力的计算
	if upgrade.id !="aex_rate":
		return
	if upgrade.maxlevel == current_upgrades["aex_rate"]["quantity"]: ##满级时将属性拉曼
		damage +=1000
		return
	var percent_reduction = current_upgrades["aex_rate"]["quantity"]*0.1 #计算应该升级多少数值
	var addAttack =  current_upgrades["aex_rate"]["quantity"]*10
	damage +=addAttack##增加攻击力
	var time:float = default_waitTimer *(1- percent_reduction )#减少等待时间
	if time <= 0:
		cool_timer.wait_time = 0.1
	else:
		cool_timer.wait_time = time 
	cool_timer.start()
	
	pass
