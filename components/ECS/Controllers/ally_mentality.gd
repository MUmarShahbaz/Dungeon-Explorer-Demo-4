extends Controller
class_name AllyMentality

@onready var myself : Ally = get_parent()
var gather : bool = true

#region CORE
@onready var VIS_Ray : RayCast2D = RayCast2D.new()

func _ready() -> void:
	VIS_Ray.set_collision_mask_value(3, true)
	myself.RayBox.add_child.call_deferred(VIS_Ray)

func _physics_process(delta: float) -> void:
	pass
#endregion

#region MISC
func find_closest_target():
	var closest_target : Enemy
	var closest_target_distance : float = INF
	for target : Enemy in get_tree().get_nodes_in_group("enemies"):
		var to_target : Vector2 = target.global_position - myself.global_position
		if to_target.x * myself.facing < 0 and to_target.length() > myself.VIS_Attack_Range: continue
		VIS_Ray.target_position = to_target
		VIS_Ray.force_raycast_update()
		if VIS_Ray.is_colliding():
			var collider = VIS_Ray.get_collider()
			if collider == target and to_target.length() < closest_target_distance:
				closest_target = target
				closest_target_distance = to_target.length()
	return closest_target

func face_target(target : Enemy):
	if (target.global_position - myself.global_position).x * myself.facing < 0:
		myself.flip()
#endregion
