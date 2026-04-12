extends Controller
class_name PlayerController

@onready var myself : Player = get_parent()
var gathered : bool = true

signal cam(cam_dir : Vector2)

func _physics_process(_delta: float) -> void:
	if myself.disable_controls: return
	cam.emit(Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down").normalized())
	if Input.is_action_just_pressed("primary"): myself.primary()
	if Input.is_action_just_pressed("secondary"): myself.secondary()
	if Input.is_action_just_pressed("regroup"): regroup()
	if Input.is_action_just_pressed("heal"): myself.heal()
	if Input.is_action_just_pressed("boost"): myself.boost()
	if myself.pause_movement(): return
	myself.move(Input.get_axis("left", "right"), Input.is_action_pressed("sprint"))
	if Input.is_action_just_pressed("jump"): myself.jump()

func regroup():
	gathered = not gathered
	var allies = get_tree().get_nodes_in_group("allies").filter(func (x : Ally):
		return x is not Player and not x.civilian and not x.puppet)
	for ally : Ally in allies:
		var controller : AllyMentality = ally.get_children().filter(func (x): return x is Controller)[0]
		controller.gather = gathered
