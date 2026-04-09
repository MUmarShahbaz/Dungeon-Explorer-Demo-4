extends Enemy
class_name Boss

func _ready() -> void:
	super._ready()
	add_to_group("boss")

func hurt(amount: float) -> void:
	if HP_Current <= 0: return
	if randf() <= 0.2: HP_Current -= amount*1.2
	else: HP_Current -= amount
	velocity.x = 0
	if HP_Current <= 0: die()
	elif randf() <= 0.5: start_anim("hurt", true)
