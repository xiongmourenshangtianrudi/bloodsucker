extends CanvasLayer

signal transition_halfway
@onready var progress_bar: ProgressBar = $ProgressBar

var skip_emit = false

func transition_in():
	$AnimationPlayer.play("transition_an")
	self.visible = true
	
	await transition_halfway  ##等待信号触发
	skip_emit = true
	$AnimationPlayer.play_backwards("transition_an")
	self.visible = false
	
	
func emit_transition_halfway():  ##应该再场景加载完毕之后触发信号
	if skip_emit:
		skip_emit = false
		return 
	transition_halfway.emit()
	
func change_to_scene(path:String):
	transition_in()
	await transition_halfway
	ScreenTransition.progress_bar.value = 1
	get_tree().change_scene_to_file(path)
	
