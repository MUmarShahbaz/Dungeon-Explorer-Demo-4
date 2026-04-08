extends Node
class_name MobMentallity

@onready var myself : Enemy = get_parent()

enum  state {patrol, pursue, pounce}
var current_state : state = state.patrol

func _physics_process(_delta: float) -> void:
	var target : Ally = myself.find_closest_target()
	match current_state:
		state.patrol:
			if target:
				current_state = state.pursue
				return
			patrol()
		state.pursue:
			if not target:
				current_state = state.patrol
				return
			if myself.to_local(target.global_position).length() < myself.VIS_Attack_Range:
				current_state = state.pounce
				return
			pursue(target)
		state.pounce:
			if not target:
				current_state = state.patrol
				return
			if myself.to_local(target.global_position).length() > myself.VIS_Attack_Range:
				current_state = state.pursue
				return
			pounce(target)

@onready var home = myself.global_position.x
var min_dist: int = 50
var max_dist: int = 100
var next_dist: float = 0
var pause: bool = false

func patrol():
	if next_dist * myself.facing < 0 : myself.flip()
	if pause: return
	myself.move(-1 if next_dist < 0 else 1)
	if home + abs(next_dist) < myself.global_position.x or home - abs(next_dist) > myself.global_position.x or myself.VIS_Block_Check.is_colliding():
		pause = true
		myself.velocity.x = 0
		home = myself.global_position.x
		next_dist = randi_range(min_dist , max_dist) if randi_range(0, 100) > 50 else randi_range(-max_dist, -min_dist)
		if myself.VIS_Block_Check.is_colliding(): next_dist = abs(next_dist) * -myself.facing
		await get_tree().create_timer(randf_range(3, 5)).timeout
		pause = false

func pursue(target : Ally):
	myself.face_target(target)
	myself.move((target.global_position - myself.global_position).normalized().x, true)

func pounce(target):
	myself.face_target(target)
	myself.velocity.x = 0
	myself.primary()
