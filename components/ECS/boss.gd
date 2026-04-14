extends Enemy
class_name Boss

func _ready() -> void:
	super._ready()
	add_to_group("boss")

func hurt(amount: float) -> void:
	if hp <= 0: return
	hp -= amount
	move(0)
	if hp <= 0: die()
	elif randf() <= 0.5: start_anim("hurt", true)
