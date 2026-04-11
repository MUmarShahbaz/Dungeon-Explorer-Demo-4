extends CanvasLayer
class_name DialogueBox

@onready var container = Control.new()
@onready var bg = ColorRect.new()
@onready var avatar_container = HBoxContainer.new()
@onready var avatar = TextureRect.new()
@onready var text_box = Label.new()

func _ready() -> void:
	add_child(container)
	container.add_child.call_deferred(bg)
	bg.add_child.call_deferred(avatar_container)
	avatar_container.add_child.call_deferred(text_box)
	avatar_container.add_child.call_deferred(avatar)
	await avatar.ready
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.anchor_left = 0
	bg.anchor_right = 1
	bg.anchor_bottom = 1
	bg.anchor_top = 0.6
	bg.color = Color("000000a5")
	avatar_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.size_flags_vertical = Control.SIZE_FILL
	text_box.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_box.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_box.theme = load("res://assets/theme/main.tres")
	text_box.add_theme_font_size_override("font_size", 35)
	avatar.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

func update_dialogue(image, text ,avatar_on_right = false):
	avatar.texture = image
	text_box.text = text + "\n\n(jump to continue...)"
	if avatar_on_right:
		avatar.flip_h = true
		avatar_container.move_child(text_box, 0)
	else:
		avatar.flip_h = false
		avatar_container.move_child(text_box, 1)
	
func begin_dialogue(dialogue_sequence : Array[Dialogue]):
	for this_dialogue in dialogue_sequence:
		while Input.is_action_pressed("jump"):
			await get_tree().physics_frame
		update_dialogue(this_dialogue.Sprite, this_dialogue.Text, this_dialogue.Right_Side)
		while not Input.is_action_just_pressed("jump"):
			await get_tree().physics_frame

func begin_dialogue_from_resource(dialogue_sequence : String):
	var this_sequence : DialogueSequence = load(dialogue_sequence)
	for this_dialogue in this_sequence.array:
		while Input.is_action_pressed("jump"):
			await get_tree().physics_frame
		update_dialogue(this_dialogue.Sprite, this_dialogue.Text, this_dialogue.Right_Side)
		while not Input.is_action_just_pressed("jump"):
			await get_tree().physics_frame
