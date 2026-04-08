extends StaticBody2D
class_name Shield

var collider

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(5, true)
	set_collision_mask_value(1, false)
	collider = get_node_or_null("CollisionShape2D")
	if not collider: collider = get_node_or_null("CollisionPolygon2D")
	deactivate()

func activate():
	collider.disabled = false

func deactivate():
	collider.disabled = true
