extends "res://script/tools/fsm/states.gd"
class_name attack

##攻击状态里再写一个状态机，进行判定是否攻击
enum attackState{
	axe,
	normalAttack,
	sprint
}

var boss_blackboard:blackBoard
var fsm:FSM
var state_duration = 0.0
var state_cool = 1
var current_state = attackState.normalAttack

var min_attack_interval = 3  # 最小攻击间隔
var max_attack_interval = 3  # 最大攻击间隔
var current_attack_interval:float
var attack_timer = 0  # 计时器，单位秒
var current_sprint_distance = 0

func _init(boss_blackboard:blackBoard,fsm:FSM) -> void:
	self.boss_blackboard = boss_blackboard
	self.fsm = fsm

func enter():
	boss_blackboard.animationTree.set("parameters/conditions/run",false)
	boss_blackboard.animationTree.set("parameters/conditions/idel",true)
	boss_blackboard.animationTree.set("parameters/conditions/attack",false)
	current_attack_interval = randf_range(min_attack_interval,max_attack_interval)
	pass
	
	
func update(delta:float):
	##攻击逻辑以及状态切换
	
	boss_blackboard.target = get_player_pos()
	
	state(delta)##状态机管理器
	if boss_blackboard.baseBody.global_position.distance_squared_to(\
		boss_blackboard.target)>100 && state_duration>= state_cool && current_state == attackState.normalAttack:
		fsm.switch_state(state_types.state_type.run)	
		state_duration = 0
	state_duration+=delta	
		
	pass
	
	
func state(delta):
	match current_state:
		attackState.axe:
			axe_behavior(delta)
		attackState.normalAttack:
			normal_attack_behavior(delta)
		attackState.sprint:
			sprint(delta)
	
func axe_behavior(delta):

	attack_timer+=delta
	boss_blackboard.animationTree.set("parameters/conditions/idel",false)
	boss_blackboard.animationTree.set("parameters/conditions/attack",true)
	if attack_timer>=current_attack_interval:
		boss_blackboard.animationTree.set("parameters/conditions/idel",false)
		boss_blackboard.animationTree.set("parameters/conditions/attack",true)
		pick_skill(1)
		attack_timer = 0
		current_attack_interval = randf_range(min_attack_interval,max_attack_interval)
		current_state = attackState.normalAttack
		boss_blackboard.animationTree.set("parameters/conditions/idel",true)
		boss_blackboard.animationTree.set("parameters/conditions/attack",false)

	pass	
	
	
func normal_attack_behavior(delta):
	 ##选择一个攻击手段
	if boss_blackboard.baseBody.get_child(0).current_health\
	<boss_blackboard.baseBody.get_child(0).max_health*0.5:
		current_state = attackState.sprint
		return
	current_state = attackState.axe
	
	pass	
func sprint(delta):
	
	attack_timer+=delta
	if attack_timer>=current_attack_interval:
		
		#var target = get_player_pos()
		#var target_dir = (target - boss_blackboard.baseBody.global_position).normalized()
		#if current_sprint_distance <= 150:
			#print("正在冲刺")
			#boss_blackboard.baseBody.velocity = 300  *target_dir
			#
			#boss_blackboard.baseBody.move_and_slide()
			##print(owner.velocity)
			#var dish_distance =  300 *delta *target_dir.length()
			#current_sprint_distance += dish_distance
			#print(current_sprint_distance)
	
			
			#current_sprint_distance = 0
		pick_skill(0)
		current_state = attackState.axe
		attack_timer = 0
		pass
	
	
	##向玩家方向进行冲刺，并造成伤害，这个需要单独做一个冲刺组件
	

	
func pick_skill(index:int):
	var skill = boss_blackboard.abilitys[index]
	skill.is_action = true
	skill.skill_release()
func move_to(target_pos:Vector2):
	boss_blackboard.navigation_agent.target_position = target_pos #给值
func get_player_pos():
	if boss_blackboard.baseBody.get_tree().get_first_node_in_group("player") !=null:
		return boss_blackboard.baseBody.get_tree().get_first_node_in_group("player").global_position	
	else: return Vector2(0,0)
	
func exit():
	print("退出attack状态")
	pass
