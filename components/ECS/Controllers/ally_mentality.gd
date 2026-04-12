extends Controller
class_name AllyMentality

@onready var myself : Ally = get_parent()
var gather : bool = true
var engaged_with : Enemy = null

#region CORE
@onready var VIS_Ray : RayCast2D = RayCast2D.new()
@onready var dist : int = 250 - (randi() % 200)

func _ready() -> void:
	myself.RayBox.add_child.call_deferred(VIS_Ray)

func _physics_process(delta: float) -> void:
	if gather:
		var to_player := QuickScripts.player.global_position - myself.global_position
		if to_player.length() > dist: myself.move(to_player.normalized().x, true)
		else: myself.move(0)
	else:
		var target : Enemy = find_closest_target()
		if target:
			var to_target := target.global_position - myself.global_position
			if to_target.length() > myself.VIS_Attack_Range: myself.move(to_target.normalized().x, true)
			else:
				engaged_with = target
				myself.move(0)
				myself.primary()
		else: myself.move(0)
#endregion

#region MISC
func get_other_ally_controllers():
	var allies = get_tree().get_nodes_in_group("allies").filter(func (x : Ally):
		return x is not Player and not x.civilian and not x.puppet and not x == self)
	var ally_controllers : Array[AllyMentality] = []
	for ally : Ally in allies:
		ally_controllers.append_array(ally.get_children().filter(func (x): return x is AllyMentality))
	return ally_controllers

func find_closest_target():
	var closest_target : Enemy
	var closest_target_distance : float = INF
	var other_ally_controllers = get_other_ally_controllers()
	for target : Enemy in get_tree().get_nodes_in_group("enemies"):
		if check_engagement(target, other_ally_controllers): continue
		var to_target : Vector2 = target.global_position - myself.global_position
		VIS_Ray.target_position = to_target
		VIS_Ray.force_raycast_update()
		if VIS_Ray.is_colliding(): continue
		if to_target.length() < closest_target_distance:
			closest_target = target
			closest_target_distance = to_target.length()
	return closest_target

func check_engagement(target : Enemy, ally_controllers : Array):
	for controller : AllyMentality in ally_controllers:
		if controller.engaged_with == target: return true
	return false
#endregion
