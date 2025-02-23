extends CharacterBody2D
class_name playerControler

@export var move_speed = 125
@export var smooth_speed = 15
@onready var playerhit_box: Area2D = $playerhitBox
@onready var damage_timer: Timer = $damageTimer
@onready var health_bar: ProgressBar = $healthBar
@onready var abilitys: Node = $abilitys
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visable: Node2D = $Visable
@export var joystic:CanvasLayer
@export var velocityComponent:VelocityComponent

var timer = 1
var enemy_hit:int = 0
var healthComponent:health_component 
var base_move_speed:float = 0.0

func _ready() -> void:
	joystic = get_tree().get_first_node_in_group("joyStick")
	healthComponent = get_node("HealthComponent")
	playerhit_box.body_entered.connect(_on_body_enter)
	playerhit_box.body_exited.connect(_on_body_exit)
	playerhit_box.area_entered.connect(_on_area_enter)
	damage_timer.timeout.connect(_on_timer_out)
	healthComponent.health_change.connect(_health_changed)
	base_move_speed = velocityComponent.move_speed
	GameEvent.ability_upgrade_added.connect(add_new_ability);
	update_healthBar()


func _physics_process(delta: float) -> void:
	var move_direction = get_movement_vector().normalized();##获取移动的方向
	#var move_direction = joystic.get_child(0).get_now_pos()
	#var speed = move_direction *move_speed;
	#velocity = velocity.lerp(speed,1-exp(-delta*smooth_speed))
	velocityComponent.set_acciption_in_direction(move_direction)
	velocityComponent.move(self,delta)
#状态机
	
	
	if move_direction.x!=0 ||move_direction.y !=0:
		var move_sign = sign(move_direction.x)
		if move_sign != 0:
			visable.scale.x = move_sign
		animation_player.play("walk")
	else:
		animation_player.play("RESET")

	
	
	
func get_movement_vector()-> Vector2: ##获取移动方式
	var movement_vector = Vector2.ZERO
	var x_movement = Input.get_action_strength("move_right"
		) - Input.get_action_strength("move_left") 
	var  y_movement = Input.get_action_strength("move_button"
		) - Input.get_action_strength("move_up")
		
	movement_vector = Vector2(x_movement,y_movement)
		
	return movement_vector;


func checkDamage():#遭受攻击
	if enemy_hit == 0 || damage_timer.is_stopped():#计时器处于停止状态
		return
	takeDamage(get_tree().get_first_node_in_group("enemySpawnControl").enemy_damage)
	$RandomStreamPlayer2d.play_random() ##播放受击声音
	damage_timer.start(timer)


func takeDamage(damage:int):
	healthComponent.damage(damage) ##动态值 后面补充
	

func bossDamage(damage:int):##用于接触技能后造成伤害
	healthComponent.damage(damage)



func _health_changed()->void:
	
	GameEvent.emit_player_damage()
	update_healthBar()



func update_healthBar():
	var persent = healthComponent.get_health_persent()
	health_bar.value = persent



	
func _on_body_enter(_body:Node2D):
	enemy_hit+=1
	
	checkDamage()#有敌人进入进行攻击判定
func _on_area_enter(area:Area2D)	->void:
	if area is hitBoxComponent && area.get_parent().is_in_group("bossAttack"):
		
		bossDamage(area.damage)
 
func _on_body_exit(_body:Node2D):
	enemy_hit-=1


func _on_timer_out():
	checkDamage()


func add_new_ability(abilty_upgrad:AbilityUpgrade,current_upgrades: Dictionary):##获得新的能力
	if abilty_upgrad is ability :
		if current_upgrades[abilty_upgrad.id]["quantity"] ==1:
			var new_ability = abilty_upgrad as ability
			abilitys.add_child(new_ability.ability_controler_scene.instantiate())
	elif abilty_upgrad.id =="move_speed_rate":
		base_move_speed = base_move_speed +(base_move_speed*current_upgrades[abilty_upgrad.id]["quantity"]*0.1)
		velocityComponent.move_speed = base_move_speed
		
	elif abilty_upgrad.id =="add_max_health":
		var max_health_rate = current_upgrades[abilty_upgrad.id]["quantity"]*100
		healthComponent.add_upgread_health(max_health_rate)
		
	elif abilty_upgrad.id == "health_back":
		healthComponent.health_back(abilty_upgrad.health)
		update_healthBar()
		
	
	
	

	
