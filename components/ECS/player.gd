extends Ally
class_name Player

#region Core
func _ready() -> void:
	super._ready()
	puppet = true
	add_to_group("players")
	var myCAM = CAM.new()
	myCAM.target = self
	add_child.call_deferred(myCAM)
	cam.connect(Callable(myCAM, "set_target_offset"))
	var myEars = AudioListener2D.new()
	add_child.call_deferred(myEars)
	myEars.make_current()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	Regeneration(delta)
	SP_Handler(delta)
	controller()
#endregion

#region Controller
signal cam(cam_dir : Vector2)
var disable_controls : bool = false

func controller():
	if disable_controls: return
	cam.emit(Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down").normalized())
	if Input.is_action_just_pressed("primary"): primary()
	if Input.is_action_just_pressed("secondary"): secondary()
	if Input.is_action_just_pressed("heal"): heal()
	if Input.is_action_just_pressed("boost"): boost()
	if pause_movement(): return
	move(Input.get_axis("left", "right"), Input.is_action_pressed("sprint"))
	if Input.is_action_just_pressed("jump"): jump()
#endregion

#region HP_SP
@export_group("Items", "ITM")
@export var ITM_Healing_Potions : int = 0
@export var ITM_Booster_Potions : int = 5
@export_range(0, 5, 0.1) var HP_Regeneration_Rate :float = 1
var SP_Special_Points : float = 0

func Regeneration(delta):
	hp += HP_Regeneration_Rate *  delta
	if hp > HitPoints: hp = HitPoints

func SP_Handler(delta):
	if SP_Special_Points > 0:
		SP_Special_Points -= delta
		SP_Effect(1.5, 1.5)
	else:
		SP_Special_Points = 0
		SP_Effect()

func SP_Effect(damage_multiplier : float = 1, attack_speed_multiplier : float = 1):
	var damagers = get_children().filter(func (x): return x is Damager)
	for damager : Damager in damagers: damager.multiplier = damage_multiplier
	ANM_Animation_Tree.set("parameters/attack_1/TimeScale/scale", attack_speed_multiplier)
	ANM_Animation_Tree.set("parameters/attack_2/TimeScale/scale", attack_speed_multiplier)
	ANM_Animation_Tree.set("parameters/attack_3/TimeScale/scale", attack_speed_multiplier)
	ANM_Animation_Tree.set("parameters/shoot/TimeScale/scale", attack_speed_multiplier)

func heal():
	if ITM_Healing_Potions > 0:
		ITM_Healing_Potions -= 1
		hp += HP_Regeneration_Rate * 60

func boost():
	if ITM_Booster_Potions > 0:
		ITM_Booster_Potions -= 1
		SP_Special_Points += 34
		if SP_Special_Points > 100: SP_Special_Points = 100
#endregion
