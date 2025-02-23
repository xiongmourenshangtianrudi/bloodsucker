extends Object
class_name FSM

var states:Dictionary={}#状态

var black_board:blackBoard
var current_state:states_interface=null
var preview_state:states_interface = null

func _init(black_board:blackBoard) -> void:
	self.black_board = black_board
	

func add_states(state_type:state_types.state_type,state:states_interface):
	if states.has(state_type):
		print("状态已经存在了。")
		return
	states[state_type]=state
	print(states)
	
func switch_state(state_type:state_types.state_type):
	print("state_type",state_type)
	if 	states.has(state_type):
		if current_state !=null:
			current_state.exit()
			preview_state = current_state

		current_state = states[state_type]
		current_state.enter()
	


func update_state(delta:float):##执行状态机
	if current_state !=null:
		current_state.update(delta)
