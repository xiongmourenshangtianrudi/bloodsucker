extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvent.player_damage.connect(_on_player_damage)
	
	
	
func _on_player_damage():
	animation_player.play("player_damage")
	pass
