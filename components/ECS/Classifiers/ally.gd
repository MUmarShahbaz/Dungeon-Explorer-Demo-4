extends Entity
class_name Ally

#region Core
func _ready() -> void:
	super._ready()
	add_to_group("allies")
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	Regeneration(delta)
	SP_Handler(delta)
#endregion

#region HP_SP
@export_group("Items", "ITM")
@export var ITM_Healing_Potions : int = 0
@export var ITM_Booster_Potions : int = 5
@export_range(0, 5, 0.1) var HP_Regeneration_Rate :float = 1
var SP_Special_Points : float = 0

func Regeneration(delta):
	HP_Current += HP_Regeneration_Rate *  delta
	if HP_Current > Health_Points: HP_Current = Health_Points

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
		HP_Current += HP_Regeneration_Rate * 60

func boost():
	if ITM_Booster_Potions > 0:
		ITM_Booster_Potions -= 1
		SP_Special_Points += 34
		if SP_Special_Points > 100: SP_Special_Points = 100
#endregion

func secondary(): pass
