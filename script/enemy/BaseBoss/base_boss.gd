extends CharacterBody2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var abilitys: Node = $abilitys
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var health_components: health_component = $health_component
@onready var hurtboxs: hurtbox = $hurtbox
@onready var random_stream_player_2d: AudioStreamPlayer2D = $RandomStreamPlayer2d
@onready var blood: GPUParticles2D = $blood


@export var current_move_speed = 200
var bossBoard:blackBoard
var Fsm:FSM #新建一个状态机
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	bossBoard = blackBoard.new() #创建一个boss属性面板
	
	

func _ready() -> void:
	health_components.died.connect(game_over) ##boss死亡
	hurtboxs.hit.connect(boss_hit)
	bossBoard.animationTree = animation_tree
	bossBoard.navigation_agent = navigation_agent
	bossBoard.target = get_tree().get_first_node_in_group("player").global_position
	bossBoard.baseBody = self
	bossBoard.abilitys = abilitys.get_children()
	bossBoard.move_speed = current_move_speed
	Fsm = FSM.new(bossBoard)
	Fsm.add_states(state_types.state_type.run,run.new(bossBoard,Fsm))
	Fsm.add_states(state_types.state_type.attack,attack.new(bossBoard,Fsm))
	Fsm.add_states(state_types.state_type.idel,idel.new(bossBoard,Fsm))
	Fsm.switch_state(state_types.state_type.run)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	Fsm.update_state(delta)##执行状态机
	
	pass
func boss_hit():
	random_stream_player_2d.play_random()
	blood.emitting = true
	##做闪烁，做血液粒子
	pass


func game_over():
	self.remove_from_group("enemy")
	self.add_to_group("die")
	set_process(false)
	
	GameEvent.game_over.emit()
	queue_free()
	pass
