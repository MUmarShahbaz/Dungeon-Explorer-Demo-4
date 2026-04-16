extends Area2D
class_name DamageZone

@onready var collider = get_children()[0]
@onready var parent : Entity = get_parent()
@onready var ray : RayCast2D = RayCast2D.new()

func _ready() -> void:
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, parent is Enemy)
	set_collision_mask_value(4, parent is Ally)
	ray.enabled = false
	if parent is Enemy: ray.set_collision_mask_value(6, true)
	await parent.ready
	parent.RayBox.add_child.call_deferred(ray)

func damage_all(amount):
	ray.enabled = true
	for body in get_overlapping_bodies():
		if body is not Entity or obstruction_check(body): continue
		body.hurt(amount)
	ray.enabled = false

func obstruction_check(target : Entity) -> bool:
	ray.target_position = target.global_position - self.global_position
	ray.force_raycast_update()
	if ray.is_colliding() : return true
	else : return false
