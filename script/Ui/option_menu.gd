extends CanvasLayer


@onready var back: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/back

@onready var all_h_slider: HSlider = %allHSlider
@onready var sfx_h_slider: HSlider = %sfxHSlider
@onready var music_h_slider: HSlider = %musicHSlider
@onready var window_button: Button = %windowButton
signal back_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	back.pressed.connect(_back)
	window_button.pressed.connect(_change_window_mode)
	all_h_slider.value_changed.connect(_update_all_sound.bind("Master"))
	sfx_h_slider.value_changed.connect(_update_all_sound.bind("sfx"))
	music_h_slider.value_changed.connect(_update_all_sound.bind("music"))
	
	
	update_dispaly()
	
func update_dispaly():
	if  DisplayServer.window_get_mode() == 	DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "全屏"
	else :
		window_button.text = "窗口"
	all_h_slider.value = get_bus_volume_persent("Master")
	sfx_h_slider.value = get_bus_volume_persent("sfx")
	music_h_slider.value = get_bus_volume_persent("music")
	
		
func get_bus_volume_persent(bus_name:String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index) #获取bus的音量
	return db_to_linear(volume_db)		

func set_bus_volume_persent(bus_name:String,persent:float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(persent)
	AudioServer.set_bus_volume_db(bus_index,volume_db) #获取bus的音量
	
	
func _back()->void:
	#get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")
	back_pressed.emit()
	pass


func _change_window_mode():
	var mode = DisplayServer.window_get_mode() ##获取窗口模式
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	update_dispaly()

func _update_all_sound(value:float,bus_name:String):
	set_bus_volume_persent(bus_name,value)
	pass
