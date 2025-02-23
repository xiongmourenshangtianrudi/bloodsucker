extends Node
class_name health_component
signal health_change
signal died
@export var max_health:float = 100
@export var healthBar:ProgressBar
@export var current_health:float

func _ready() -> void:
	
	if owner.is_in_group("player"):
		max_health += MetaPrograssionManager.get_meta_upgrade_count("health_upgrad")*100
		update_health_ui(max_health)
	
	current_health = max_health
	
	if owner.is_in_group("Boss"):
		GameEvent.update_boss_state.emit("boss_test",max_health,current_health)
	
func damage(attack:float):
	
	current_health = max(current_health - attack,0)
	if current_health ==0:
		#call_deferred("check_died")
		Callable(check_died).call_deferred()#帧后运行
	if 	 owner.is_in_group("player"):
		update_health_ui(current_health)
	if owner.is_in_group("Boss"):
		GameEvent.update_boss_state.emit("boss_test",max_health,current_health)
	health_change.emit()
	
func get_health_persent()->float: #获取血量百分比
	if current_health<=0:
		return 0
	return min(current_health/max_health,1)
	
func health_back(health:float)->void:
	current_health +=health
	current_health = clampf(current_health,0,max_health)
	update_health_ui(current_health)
	
func check_died():
	if owner.is_in_group("player"):
		GameEvent.player_died.emit() #触发死亡信号
		owner.queue_free()
	elif owner.is_in_group("enemy"):
		died.emit()
		
func add_upgread_health(rate:float):
	max_health +=rate
	current_health = max_health
	update_health_ui(current_health)
		
func update_health_ui(health:float): #更新用户界面的数据
	GameEvent.emit_update_player_state(health)
