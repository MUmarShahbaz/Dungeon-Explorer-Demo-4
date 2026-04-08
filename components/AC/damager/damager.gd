extends Node
class_name Damager

@onready var parent = get_parent() as Entity
@export var Move_List : Array[AttackInfo]
@export var cooldown : int = 3
var is_cooldown : bool = false
var attacks_since_last_cooldown : int = 0
var multiplier : float = 1
var attacking = null

func _process(_delta: float) -> void:
	if is_cooldown and not parent is Player: return
	if attacking:
		if parent.check_anim(attacking) == false:
			attacking = null
	else:
		for this_attack : AttackInfo in Move_List:
			if parent.check_frame(this_attack.Animation_Name, this_attack.Animation_Frame):
				attacking = this_attack.Animation_Name
				attack(this_attack)
				try_cooldown()

func try_cooldown():
	attacks_since_last_cooldown += 1
	if attacks_since_last_cooldown >= cooldown:
		is_cooldown = true
		attacks_since_last_cooldown = 0
		await get_tree().create_timer(2).timeout
		is_cooldown = false

func get_avg_damage():
	var sum_damages : float = 0
	for this_attack : AttackInfo in Move_List:
		sum_damages += this_attack.Damage
	return int(sum_damages / Move_List.size())

func attack(attack_info : AttackInfo):
	pass
