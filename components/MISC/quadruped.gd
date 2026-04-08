extends Node
class_name QuadrupedHandler

@onready var parent : Entity = get_parent()

func _physics_process(delta: float) -> void:
	var facing = parent.facing
	var rotation = parent.rotation
	if parent.is_on_floor():
		var new_rotation = parent.get_floor_normal().angle() + deg_to_rad(90)*facing
		if abs(new_rotation - rotation) < 90: parent.rotation = rotate_toward(rotation, new_rotation, delta*3)
		else: parent.rotation = new_rotation
		parent.RayBox.rotation = -rotation*facing - (PI if facing == -1 else 0.0)
