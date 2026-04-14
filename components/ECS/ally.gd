extends Entity
class_name Ally

#region Core
enum state {Stand, Follow, Patrol, Charge}
var current_state : state = state.Patrol
var use_secondary : bool = false

func _ready() -> void:
	super._ready()
	add_to_group("allies")
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	prepare_block_check_ray()
	add_child.call_deferred(block_check_ray)
	RayBox.add_child.call_deferred(vision_ray)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if puppet: return
	check_state_change()
	var target : Entity = find_closest_target()
	if target: charge(target)
	else: match current_state:
		state.Stand: stand()
		state.Patrol: patrol()
		state.Follow: follow()
		state.Charge: charge(find_closest_target(true))

func check_state_change():
	if Input.is_action_just_pressed("army_stand"):
		if current_state == state.Stand: use_secondary = !use_secondary
		else: current_state = state.Stand
	if Input.is_action_just_pressed("army_follow"): current_state = state.Follow
	if Input.is_action_just_pressed("army_patrol"): current_state = state.Patrol
	if Input.is_action_just_pressed("army_charge"): current_state = state.Charge
#endregion

#region Stand
func stand():
	if use_secondary: secondary()
	else: move(0)
#endregion

#region Follow
@onready var follow_dist : int = 250 - (randi() % 200)

func follow():
	if not QuickScripts.player: return
	var to_player := QuickScripts.player.global_position - global_position
	if to_player.length() > follow_dist + 50: move(to_player.normalized().x, true)
	elif to_player.length() > follow_dist: move(to_player.normalized().x)
	else: move(0)
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

@export var path_checker : Vector2 = Vector2(5, 50)
func prepare_block_check_ray():
	block_check_ray.target_position = Vector2(path_checker.x, 0)
	block_check_ray.global_position = collider.shape.get_rect().end
	block_check_ray.global_position.y -= path_checker.y
#endregion

#region Charge
@onready var vision_ray : RayCast2D = RayCast2D.new()
var engaged_with : Entity = null
@export_group("Target Detection Range" , "TDR")
@export var TDR_front : float = 200
@export var TDR_back : float = 50

func charge(target : Entity):
	var to_target := target.global_position - global_position
	if to_target.length() > Attack_Range: move(to_target.normalized().x, true)
	else:
		engaged_with = target
		move(0)
		primary()

func find_closest_target(outside_range : bool = false) -> Entity:
	var closest_target : Entity = null
	var closest_target_distance : float = INF
	var allies := get_tree().get_nodes_in_group("allies").filter(func (x : Ally): return not x.puppet and not x is Player)
	for target : Entity in get_tree().get_nodes_in_group("enemies"):
		var to_target : Vector2 = target.global_position - global_position
		if check_engagement(target, allies) or \
		   to_target.length() > closest_target_distance: continue
		if not outside_range and \
		   (to_target.length() > TDR_front or \
		   (to_target.length() > TDR_back and to_target.x * facing < 0)): continue
		vision_ray.target_position = to_target
		vision_ray.force_raycast_update()
		if not vision_ray.is_colliding():
			closest_target = target
			closest_target_distance = to_target.length()
	return closest_target

func check_engagement(target : Entity, allies : Array) -> bool:
	for ally in allies: if ally.engaged_with == target: return true
	return false

func primary(): pass
func secondary(): pass
#endregion
