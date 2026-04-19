extends Entity
class_name Civillian

#region Core
func _ready() -> void:
	super._ready()
	add_to_group("civillian")
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	prepare_block_check_ray()
	add_child.call_deferred(block_check_ray)
	RayBox.add_child.call_deferred(vision_ray)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if puppet: return
	var threat : Entity = find_closest_threat()
	if threat: run_away(threat)
	else: patrol()
#endregion

#region Patrol
@onready var block_check_ray : RayCast2D = RayCast2D.new()
@onready var home = global_position.x
var next_dist: float = 0
var pause: bool = false

func patrol():
	if pause: return
	move(-1 if next_dist < 0 else 1)
	if abs(global_position.x - home) > abs(next_dist) or block_check_ray.is_colliding():
		move(0)
		pause = true
		home = global_position.x
		next_dist = randi_range(50, 100) * (1 if randf() < 0.5 else -1)
		if block_check_ray.is_colliding(): next_dist = abs(next_dist) * -facing
		await get_tree().create_timer(randf_range(3, 5)).timeout
		pause = false

@export var path_checker : Vector2 = Vector2(200, 5)
func prepare_block_check_ray():
	block_check_ray.target_position = Vector2(path_checker.x, 0)
	block_check_ray.global_position = collider.shape.get_rect().end
	block_check_ray.global_position.y -= path_checker.y
#endregion

#region Run Away
@onready var vision_ray : RayCast2D = RayCast2D.new()
@export_group("Threat Detection Range" , "TDR")
@export var TDR_front : float = 200
@export var TDR_back : float = 50

func run_away(threat : Entity):
	if not threat: return
	var to_threat := threat.global_position - global_position
	move(-to_threat.normalized().x, true)

func find_closest_threat() -> Entity:
	var closest_threat : Entity = null
	var closest_threat_distance : float = INF
	for threat : Entity in get_tree().get_nodes_in_group("enemies").filter(func (x : Enemy): return not x.name.contains("dead")):
		var to_threat : Vector2 = threat.global_position - global_position
		if to_threat.length() > closest_threat_distance or \
		   to_threat.length() > TDR_front or \
		   (to_threat.length() > TDR_back and to_threat.x * facing < 0): continue
		vision_ray.target_position = to_threat
		vision_ray.force_raycast_update()
		if not vision_ray.is_colliding():
			closest_threat = threat
			closest_threat_distance = to_threat.length()
	return closest_threat
#endregion
