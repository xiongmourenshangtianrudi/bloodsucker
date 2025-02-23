extends "res://script/tools/fsm/states.gd"


class_name run
var boss_blackboard:blackBoard
var fsm:FSM
var state_duration = 0.0
var state_cool = 1

func _init(boss_blackboard:blackBoard,fsm:FSM) -> void:
	self.boss_blackboard = boss_blackboard
	self.fsm = fsm

func enter():
	boss_blackboard.animationTree.set("parameters/conditions/run",true)
	boss_blackboard.animationTree.set("parameters/conditions/idel",false)
	boss_blackboard.animationTree.set("parameters/conditions/attack",false)
	pass
	
	
func update(delta:float):
	##更新位置，获取目标
	boss_blackboard.target =get_player_pos()	
	move_to(get_player_pos())
	boss_blackboard.navi_next_pos = boss_blackboard.navigation_agent.get_next_path_position()
	if boss_blackboard.baseBody.global_position.distance_to(boss_blackboard.target)>=100:
		# 角色朝着目标位置移动
		var direction = (boss_blackboard.navi_next_pos - boss_blackboard.baseBody.global_position).normalized()
		if direction.x>0:
			boss_blackboard.baseBody.get_child(1).scale.x=0.3
		else:
			boss_blackboard.baseBody.get_child(1).scale.x=-0.3
		boss_blackboard.baseBody.velocity = direction*boss_blackboard.move_speed
		boss_blackboard.baseBody.move_and_slide()
	else:
		if state_duration>state_cool:
			fsm.switch_state(state_types.state_type.attack)
			state_duration = 0
		state_duration +=delta
		
		
		
func move_to(target_pos:Vector2):
	boss_blackboard.navigation_agent.target_position = target_pos #给值
func get_player_pos():
	if boss_blackboard.baseBody.get_tree().get_first_node_in_group("player") !=null:
		return boss_blackboard.baseBody.get_tree().get_first_node_in_group("player").global_position	
	else: return Vector2(0,0)
	
func exit():
	print("退出run状态")
	pass
