extends Entity
class_name Enemy

#region Core
func _ready() -> void:
	super._ready()
	add_to_group("enemies")
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, true)
	prepare_block_check_ray()
	add_child.call_deferred(block_check_ray)
	RayBox.add_child.call_deferred(vision_ray)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if puppet: return
	var target : Entity = find_closest_target()
	if target: charge(target)
	else: patrol()
#endregion

#region Patrol
@onready var block_check_ray : RayCast2D = RayCast2D.new()
@onready var home = global_position.x
@export_group("Patrol Dist", "PDist")
@export var PDist_min : int = 50
@export var PDist_max : int = 100
var next_dist: float = 0
var pause: bool = false

func patrol():
	if pause: return
	move(-1 if next_dist < 0 else 1)
	if abs(global_position.x - home) > abs(next_dist) or block_check_ray.is_colliding():
		move(0)
		pause = true
		home = global_position.x
		next_dist = randi_range(PDist_min, PDist_max) * (1 if randf() < 0.5 else -1)
		if block_check_ray.is_colliding():
			next_dist = abs(next_dist) * -facing
			flip()
		await get_tree().create_timer(randf_range(3, 5)).timeout
		pause = false

@export var path_checker : Vector2 = Vector2(200, 5)
func prepare_block_check_ray():
	block_check_ray.target_position = Vector2(path_checker.x, 0)
	block_check_ray.global_position = collider.shape.get_rect().end
	block_check_ray.global_position.y -= path_checker.y
#endregion

#region Charge
@onready var vision_ray : RayCast2D = RayCast2D.new()
@export_group("Target Detection Range" , "TDR")
@export var TDR_front : float = 200
@export var TDR_back : float = 50

func charge(target : Entity):
	var to_target := target.global_position - global_position
	if to_target.length() > Attack_Range: move(to_target.normalized().x, true)
	else:
		if to_target.x * facing < 0: flip()
		move(0)
		primary()

func find_closest_target() -> Entity:
	var closest_target : Entity = null
	var closest_target_distance : float = INF
	for target : Entity in get_tree().get_nodes_in_group("allies").filter(func (x : Ally): return not x.name.contains("dead")):
		var to_target : Vector2 = target.global_position - global_position
		if to_target.length() > closest_target_distance or \
		   to_target.length() > TDR_front or \
		   (to_target.length() > TDR_back and to_target.x * facing < 0): continue
		vision_ray.target_position = to_target
		vision_ray.force_raycast_update()
		if not vision_ray.is_colliding():
			closest_target = target
			closest_target_distance = to_target.length()
	return closest_target

func primary(): pass
#endregion
