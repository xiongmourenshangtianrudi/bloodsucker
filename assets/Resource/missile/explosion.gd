extends GPUParticles2D
@onready var random_stream_player_2d: AudioStreamPlayer2D = $RandomStreamPlayer2d


func _ready() -> void:
	random_stream_player_2d.play_random()
	restart()

func _on_finished() -> void:
	queue_free()
