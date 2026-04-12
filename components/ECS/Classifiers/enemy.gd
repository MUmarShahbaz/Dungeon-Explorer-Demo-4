extends Entity
class_name Enemy

#region Core
@export_group("Vision", "VIS")
@onready var VIS_Ray : RayCast2D = RayCast2D.new()
@onready var VIS_Block_Check : RayCast2D = RayCast2D.new()
@export var VIS_Range : float

func _ready() -> void:
	super._ready()
	add_to_group("enemies")
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	if not puppet: add_child.call_deferred(MobMentallity.new())
	VIS_Ray.set_collision_mask_value(2, true)
	VIS_Block_Check.target_position = Vector2(50, 0)
	VIS_Block_Check.global_position = Collider.shape.get_rect().end
	VIS_Block_Check.global_position.y -= 5
	RayBox.add_child.call_deferred(VIS_Ray)
	add_child.call_deferred(VIS_Block_Check)
#endregion

#region Misc
func find_closest_target():
	var closest_target : Ally
	var closest_target_distance : float = INF
	for target : Ally in get_tree().get_nodes_in_group("allies"):
		var to_target : Vector2 = target.global_position - self.global_position
		if to_target.x * facing < 0 and to_target.length() > VIS_Attack_Range: continue
		if to_target.length() > VIS_Range: continue
		VIS_Ray.target_position = to_target
		VIS_Ray.force_raycast_update()
		if VIS_Ray.is_colliding():
			var collider = VIS_Ray.get_collider()
			if collider == target and to_target.length() < closest_target_distance:
				closest_target = target
				closest_target_distance = to_target.length()
	return closest_target

func face_target(target : Ally):
	if (target.global_position - self.global_position).x * facing < 0:
		flip()
#endregion
