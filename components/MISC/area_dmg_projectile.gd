extends Projectile
class_name AreaDamageProjectile

@export var blast_radius : Area2D

func _ready() -> void:
	super._ready()
	blast_radius.set_collision_mask_value(4 if launched_by is Ally else 3, true)
	blast_radius.set_collision_mask_value(6, true)

func _physics_process(_delta: float) -> void:
	var bodies = get_colliding_bodies()
	if bodies.size() > 0:
		for body in blast_radius.get_overlapping_bodies():
			if body is Entity:
				(body as Entity).hurt(damage)
				(body as Entity).velocity.x += 10*direction
		queue_free()

func flip():
	super.flip()
	blast_radius.scale.x *= -1
