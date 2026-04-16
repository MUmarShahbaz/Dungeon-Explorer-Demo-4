@abstract
extends CharacterBody2D
class_name Entity

#region Character Stats
enum character_type {Civillian, Melee, Projectile, Boss}
@export var avatar : Texture2D
@export var title : String
@export var type : character_type
@export_group("Stats")
@export var HitPoints : float = 100
@export var Walk_Speed : float = 100
@export var Run_Speed : float = 300
@export var Jump_Force : float = 300
@export var Attack_Range : float = 50

func get_card_data() -> Dictionary:
	var damagers = get_children().filter(func (x): return x is Damager)
	var avg_dmg : int
	if damagers.size() > 0:
		var sum_damages : int = 0
		for this_damager : Damager in damagers: sum_damages += this_damager.get_avg_damage()
		@warning_ignore("integer_division")
		avg_dmg = int(sum_damages / damagers.size())
	else: avg_dmg = 0
	return {
		"avatar": avatar,
		"title": title,
		"type": character_type.keys()[type],
		"hp": int(HitPoints),
		"dmg": avg_dmg,
		"spd": int(Run_Speed / 10),
		"rng": int(Attack_Range / 10),
	}
#endregion

#region Meta
@export_category("Meta")
@export var puppet : bool = false
@export var collider : CollisionShape2D
@export_group("Animation", "ANM")
@export var ANM_Animated_Sprite : AnimatedSprite2D
@export var ANM_Animation_Player : AnimationPlayer
@export var ANM_Animation_Tree : AnimationTree
@export_group("Dialogue Images", "DIA")
@export var DIA_Aggression : Texture2D
@export var DIA_Calm : Texture2D
@export var DIA_Sadness : Texture2D
@export var DIA_Smile : Texture2D
@export var DIA_Special : Texture2D
@export var DIA_Talk : Texture2D
@export_group("Sound Effects", "SFX")
@export var SFX_Walk : AudioStreamPlayer2D
@export var SFX_Run : AudioStreamPlayer2D
@export var SFX_Jump : AudioStreamPlayer2D
@export var SFX_Hurt : AudioStreamPlayer2D
@export var SFX_Die : AudioStreamPlayer2D
#endregion

#region Core
@onready var hp = HitPoints
@onready var RayBox := Node2D.new()
var facing : int = 1
signal entity_died

func _ready() -> void:
	add_to_group("entities")
	add_child.call_deferred(RayBox)
	set_collision_mask_value(2, true)

func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta
	if velocity.x != 0: velocity.x = move_toward(velocity.x, 0, delta*10)
	move_and_slide()

func flip() -> void:
	facing *= -1
	scale.x *= -1
	RayBox.scale.x = facing
#endregion

#region Movement
var pause_on_anims : Array[String] = ["attack_1", "attack_2", "attack_3", "protect", "shoot", "die"]
var force_pause : bool = false
func pause_movement():
	if force_pause: return true
	for anim in pause_on_anims: if check_anim(anim) : return true
	return false
func quick_pause(duration : float = 0.3):
	force_pause = true
	await get_tree().create_timer(duration).timeout
	force_pause = false

func move(x_dir : float, run : bool = false):
	if pause_movement():
		velocity.x = 0
		return
	var delta = get_physics_process_delta_time()
	if x_dir != 0:
		if run:
			velocity.x = x_dir * Run_Speed * delta * 60
			if is_on_floor():
				start_anim("run")
		else:
			velocity.x = x_dir * Walk_Speed * delta * 50
			if is_on_floor():
				start_anim("walk")
	else:
		velocity.x = 0
	if x_dir * facing < 0 : flip()

func jump(force := Jump_Force):
	if pause_movement() or not is_on_floor() or check_anim("jump"): return
	velocity.y -= force
	quick_pause(0.01)
	start_anim("jump")
#endregion

#region HP
func kill():
	hurt(hp)

func hurt(amount: float) -> void:
	if hp <= 0: return
	hp -= amount
	velocity.x = 0
	if hp <= 0: die()
	else: start_anim("hurt", true)

func die():
	set_process(false)
	set_physics_process(false)
	velocity.x = 0
	name = str(title + "-dead_" + str(randi()))
	collider.set_deferred("disabled", true)
	await force_anim("die")
	entity_died.emit()
	queue_free()
#endregion

#region ANM
func check_anim(animation : String) -> bool:
	return ANM_Animated_Sprite.animation == animation

func check_frame(animation : String, frame : int) -> bool:
	return ANM_Animated_Sprite.animation == animation and ANM_Animated_Sprite.frame == frame

func await_frame(animation: String, frame : int) -> void:
	while !check_frame(animation, frame):
		await get_tree().process_frame
	return

func start_anim(animation : String, force : bool = false):
	if force: ANM_Animation_Tree.get("parameters/playback").start(animation)
	else: ANM_Animation_Tree.get("parameters/playback").travel(animation)

func force_anim(animation : String):
	while not check_frame(animation, ANM_Animated_Sprite.sprite_frames.get_frame_count(animation) - 1):
		if not check_anim(animation): start_anim(animation, true)
		await get_tree().process_frame
	return
#endregion
