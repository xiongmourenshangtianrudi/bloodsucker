extends Node

const SAVE_FILE_PATH = "user://saves"



var save_data:Dictionary = {
	"meta_upgrade_currency":0,
	"meta_upgrades":{}
}


func _ready() -> void:
	GameEvent.emit_experence_vial_collect.connect(on_experience_collected)
	load_save_file()
	
	
	
func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH+"/game.save"): ##文件不存在，就跳过
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH+"/game.save",FileAccess.READ)
	save_data = file.get_var()
	print(save_data)

func save_file()	:
	var dir = DirAccess.open(SAVE_FILE_PATH)
	if  dir == null:
		dir = DirAccess.open("user://")
		dir.make_dir("saves") ##创建一个save文件夹
	var file = FileAccess.open(SAVE_FILE_PATH+"/game.save",FileAccess.WRITE)
	file.store_var(save_data)
	
	
func add_meta_upgrades(upgrade:meta_upgrade):
	
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity":0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save_data["meta_upgrade_currency"] -= upgrade.experence_coast
	save_file()
	
func get_meta_upgrade_count(id:String)->float:
	if save_data["meta_upgrades"].has(id):
		return save_data["meta_upgrades"][id]["quantity"]
	else:
		return 0
	
func on_experience_collected(number:float):
	save_data["meta_upgrade_currency"] += number
