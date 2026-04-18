extends RigidBody2D
## A shootable element that causes damage on impact. Can be shot using a [ProjectileLauncher]
class_name Projectile

@export var sprite: AnimatedSprite2D
@export var collider: CollisionShape2D
@export var damage : int = 10
@export var hit_sfx : AudioStreamPlayer2D

var direction : int
var launched_by : CharacterBody2D

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(5, true)
	set_collision_mask_value(4 if launched_by is Ally else 3, true)
	set_collision_mask_value(6, true)
	gravity_scale = 0
	lock_rotation = true
	contact_monitor = true
	max_contacts_reported = 1
	if direction == -1 : flip()
	if hit_sfx: hit_sfx.bus = &"SFX"
	while true:
		await get_tree().create_timer(2).timeout
		if abs(linear_velocity.x) < 100: queue_free()

func flip():
	sprite.scale.x *= -1
	collider.scale.x *= -1

func _physics_process(_delta: float) -> void:
	var bodies = get_colliding_bodies()
	if bodies.size() > 0:
		if hit_sfx:
			hide()
			set_physics_process(false)
			hit_sfx.play()
		if bodies[0] is Entity:
			(bodies[0] as Entity).hurt(damage)
			(bodies[0] as Entity).velocity.x += 10*direction
		if hit_sfx: await get_tree().create_timer(hit_sfx.stream.get_length() + 0.1).timeout
		queue_free()

func launch(force : int) -> void:
	apply_impulse(Vector2(force * direction, 0))
