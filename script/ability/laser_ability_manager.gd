extends Node
@export var laser:PackedScene
@export var damage:int =25 ##激光的伤害
var dir:Vector2
var laser_pool :object_pool
var forground:Node2D
@onready var timer: Timer = $Timer
var laser_num:int = 1
var timer_keep:float = 1

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	forground = get_tree().get_first_node_in_group("forground")
	laser_pool = object_pool.new()
	laser_pool._init_object_pool(laser,forground)
	timer.start(3)
	GameEvent.ability_upgrade_added.connect(upgrade_added)
	
		
		
func _on_timer_timeout() -> void:
	dir = (get_viewport().get_camera_2d().get_global_mouse_position() -get_parent().get_parent().global_position).normalized() 	
	
	for i in laser_num:
		var n = i
		if i %2 !=0:
			n = -n
		var newdir = dir.rotated(deg_to_rad(15*n))
		print("newdir",newdir)
		var instance = laser_pool.get_laser() as laserability
		instance.offset_deg = 15*n
		instance.target_direction = newdir
		instance.timer_keep = timer_keep
		instance.hit_box_component.damage = damage
		instance.start()
		timer.start(3)

		
func upgrade_added(upgrade:AbilityUpgrade,current_upgrades: Dictionary):#用于升级这个能力的计算
	if upgrade.id !="laser_rate":
		return
	var level = current_upgrades["laser_rate"]["quantity"] #计算应该升级多少数值
	print(level)
	
	if level<=2 :
		self.laser_num = 1
	else:
		self.laser_num = int(level / 2)
	
	timer_keep= timer_keep+level*0.01
	damage= damage +15* (level -1)
	timer.start()
	
			
		
		
