extends Node2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@export var health:health_component
@export var texture:Texture
var calcing:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gpu_particles_2d.texture =texture
	health.died.connect(on_died)
	
	
func on_died():
	if owner == null || not owner is Node2D:
		return
	gpu_particles_2d.emitting = true
	calcing = false
	await get_tree().create_timer(0.75).timeout
	owner.queue_free()
	

#func wait_next_idframe():
	
