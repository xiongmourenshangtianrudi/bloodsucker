extends Node


@export var upgrade_poor:Array[AbilityUpgrade] ##这里保存游戏的能力
@export var other_chosen:Array[AbilityUpgrade] ##增加的变体能力，不设计新的攻击方式
@export var have_been_ability:Array[AbilityUpgrade]


@export var up_grade_screen:PackedScene

@export var experence_Manager:experenceManager

var current_upgrades = {} #保存已经获取到的能力  已经获取的能力

##当学满5个能力后，就不再能学习新的能力

func _ready() -> void:
	experence_Manager.level_up.connect(on_level_up)
	
func on_level_up(current_level:int):
	
	##选择两个升级属性
	#var chosens:Array[AbilityUpgrade] = []
	#for i in 3:
		#var chosen_upgrades:AbilityUpgrade = upgrade_poor.pick_random() #在升级中获取一个随机的升级选项
		#
		#if chosen_upgrades==null:
			#return
		#chosens.append(chosen_upgrades)
	var upgreadsence_instance = up_grade_screen.instantiate()
	add_child(upgreadsence_instance)
	upgreadsence_instance.set_ability_upgrades(pick_upgrades())
	upgreadsence_instance.upgrade_selected.connect(_on_upgrade_selected)


func pick_upgrades()->Array[AbilityUpgrade]:
	var filtered_upgrade = upgrade_poor.duplicate(true) ##复制数组
	if have_been_ability.size() >=5:
		filtered_upgrade = have_been_ability
		filtered_upgrade.append_array(other_chosen)
	var chosens:Array[AbilityUpgrade] = []
	for i in 2:
		if filtered_upgrade.size() ==0:
			break
		var chosen_upgrades:AbilityUpgrade = filtered_upgrade.pick_random() #在升级中获取一个随机的升级选项
		#filtered_upgrade.erase(chosen_upgrades)
		
		filtered_upgrade = filtered_upgrade.filter(func (upgrade):return upgrade.id !=chosen_upgrades.id) #将已经选择的过滤掉
		chosens.append(chosen_upgrades)	
	return chosens


func apply_upgrade(upgread:AbilityUpgrade):##告知游戏事件升级
	var has_upgrade = current_upgrades.has(upgread.id)
	if !"other" in upgread: ##有other属性的升级项目不放到升级状态里去
		if !has_upgrade:
			current_upgrades[upgread.id] = {
				"resource":upgread,
				"quantity":1
			}
			have_been_ability.append(upgread)
		else:
			current_upgrades[upgread.id]["quantity"]+=1 #
	
		if upgread.maxlevel >0:
			var current_quantity = current_upgrades[upgread.id]["quantity"]
			if current_quantity == upgread.maxlevel:
				have_been_ability = have_been_ability.filter(func (pool_upgrade):return pool_upgrade.id !=upgread.id) ##过滤池子
				upgrade_poor = upgrade_poor.filter(func (pool_upgrade):return pool_upgrade.id !=upgread.id) ##过滤池子
	GameEvent.emit_ability_upgrade_added(upgread,current_upgrades)
	get_tree().paused = false
		
func _on_upgrade_selected(upgrade:AbilityUpgrade)->void: #用于触发升级
	apply_upgrade(upgrade)
