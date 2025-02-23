extends Node
class_name hitFlashComponment

@export var healthComponment:health_component
@export var sprite:Sprite2D


@export var hit_flash_componment_material:ShaderMaterial
var hit_flash_tween:Tween
func _ready() -> void:
	healthComponment.health_change.connect(_on_health_changed)
	sprite.material = hit_flash_componment_material ##确保材质生效


func _on_health_changed():
	if hit_flash_tween !=null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
		
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_persent",1)	
	hit_flash_tween = create_tween() ##创建一个动画器
	hit_flash_tween.tween_property(sprite.material,"shader_parameter/lerp_persent",0.0,.2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	pass
