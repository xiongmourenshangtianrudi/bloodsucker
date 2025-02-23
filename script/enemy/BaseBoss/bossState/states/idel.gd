extends "res://script/tools/fsm/states.gd"

class_name idel
var boss_blackboard:blackBoard
var fsm:FSM
var current

func _init(boss_blackboard:blackBoard,fsm:FSM) -> void:
	self.boss_blackboard = boss_blackboard
	self.fsm = fsm

func enter():
	boss_blackboard.animationTree.set("parameters/conditions/run",false)
	boss_blackboard.animationTree.set("parameters/conditions/idel",true)
	boss_blackboard.animationTree.set("parameters/conditions/attack",false)
	pass
	
	
func update(elta:float):
	##更新位置，获取目标
	
	pass
	


func get_player_pos():
	return boss_blackboard.get_tree().get_first_node_in_group("player").global_position	
	
func exit():
	print("退出run状态")
	pass
