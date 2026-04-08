extends Controller
class_name PlayerController

@onready var myself : Player = get_parent()

signal cam(cam_dir : Vector2)

func _physics_process(_delta: float) -> void:
	cam.emit(Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down").normalized())
	if Input.is_action_just_pressed("primary"): myself.primary()
	if Input.is_action_just_pressed("secondary"): myself.secondary()
	if Input.is_action_just_pressed("heal"): myself.heal()
	if Input.is_action_just_pressed("boost"): myself.boost()
	if myself.pause_movement(): return
	myself.move(Input.get_axis("left", "right"), Input.is_action_pressed("sprint"))
	if Input.is_action_just_pressed("jump"): myself.jump()
