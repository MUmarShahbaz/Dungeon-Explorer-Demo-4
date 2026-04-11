extends Camera2D
## This camera should be used to focus on the controllable character
class_name CAM

var target: CharacterBody2D
@export_range(0.0, 1.0, 0.01) var smoothing: float = 0.5
@export var offset_distance: Vector2 = Vector2(120, 60)
var target_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	zoom = Vector2.ONE * 2.5
	limit_smoothed = true
	position_smoothing_enabled = true
	make_current()

func _physics_process(_delta: float) -> void:
	if target:
		global_position = lerp(global_position, target.global_position + target_offset, smoothing)

func set_target_offset(new_offset: Vector2):
	target_offset.x = new_offset.x * offset_distance.x
	target_offset.y = new_offset.y * offset_distance.y
