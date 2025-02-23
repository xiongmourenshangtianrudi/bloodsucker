extends CanvasLayer
signal upgrade_selected(upgrade:AbilityUpgrade)
@export var upgrade_card_scene:PackedScene
@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	

func set_ability_upgrades(upgrades:Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var upgrade_card = upgrade_card_scene.instantiate()
		card_container.add_child(upgrade_card)
		upgrade_card.set_ability_upgrade(upgrade)
		upgrade_card.play_in(delay)
		upgrade_card.selected.connect(_on_selected.bind(upgrade))
		delay+=0.2


func _on_selected(upgrade:AbilityUpgrade)->void:
	upgrade_selected.emit(upgrade)
	animation_player.play("backgroundOut")
	await animation_player.animation_finished
	queue_free()
