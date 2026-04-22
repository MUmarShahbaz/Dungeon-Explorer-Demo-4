extends Node

@onready var pause_menu = preload("res://ui/pause_menu.tscn").instantiate()

func _ready() -> void:
	add_child.call_deferred(pause_menu)
	prepare_bg_music()


#region Playable Characters
var playable : Array[StringName] = ["KNIGHT", "WIZARD", "SAMURAI", "NINJA"]
var all_characters = {
	"KNIGHT": {
		"scene": "res://scenes/characters/pc/knight.tscn",
		"image": "res://assets/sprites/knight.png"
	},
	"WIZARD": {
		"scene": "res://scenes/characters/pc/wizard.tscn",
		"image": "res://assets/sprites/wizard.png"
	},
	"SAMURAI": {
		"scene": "res://scenes/characters/pc/samurai.tscn",
		"image": "res://assets/sprites/samurai.png"
	},
	"NINJA": {
		"scene": "res://scenes/characters/pc/ninja.tscn",
		"image": "res://assets/sprites/ninja.png"
	},
	"DWARF": {},
	"WITCH": {}
	# Mercenraries
	#"ELF": {},
	#"GLADIATOR": {},
	#"AMAZON": {},
	#"PYROMANCER": {}
}
#endregion

#region Player Spawner
var selector_file : PackedScene = preload("res://scenes/player_spawner/player_selector.tscn")
var hud_file : PackedScene = preload("res://scenes/player_spawner/hud.tscn")

signal player_spawned(player : Player)

var selected : Dictionary
var hp_potions : int = 0
var player : Player
var hud : CanvasLayer

func new_spawn():
	var new_selector = selector_file.instantiate()
	(new_selector.continue_btn as Button).pressed.connect(func ():
		if new_selector.selected:
			selected = new_selector.selected
			new_selector.queue_free()
			spawn()
	)
	get_tree().get_current_scene().add_child.call_deferred(new_selector)

func spawn():
	if not selected:
		await new_spawn()
		return
	var current_scene : Level = get_tree().get_current_scene()

	var new_player : Player = load(selected[&"scene"]).instantiate()
	new_player.global_position = current_scene.player_spawn_position
	new_player.ITM_Healing_Potions = hp_potions
	current_scene.add_child.call_deferred(new_player)

	var new_hud = hud_file.instantiate()
	new_hud.player = new_player
	new_hud.avatar = AtlasTexture.new()
	new_hud.avatar.atlas = load(selected[&"image"])
	new_hud.avatar.region.position = Vector2(16, 8)
	new_hud.avatar.region.size = Vector2(32, 32)
	current_scene.add_child.call_deferred(new_hud)

	if player: player.queue_free()
	player = new_player
	hud = new_hud
	while not player.is_node_ready() and not hud.is_node_ready():
		await get_tree().physics_frame
	player_spawned.emit(new_player)

	return new_player
#endregion

#region Audio Handler
@onready var bg_player = AudioStreamPlayer.new()
@onready var audio_master_bus = AudioServer.get_bus_index("Master")
@onready var audio_music_bus = AudioServer.get_bus_index("Music")
@onready var audio_sfx_bus = AudioServer.get_bus_index("SFX")

func prepare_bg_music():
	add_child.call_deferred(bg_player)
	bg_player.stream = load("res://assets/audio/bg.mp3")
	bg_player.bus = &"Music"
	bg_player.autoplay = true
	bg_player.process_mode = Node.PROCESS_MODE_ALWAYS
	bg_player.set_deferred("parameters/looping", true)
#endregion

#region Entities
var shadows : bool = false

func move_entity(to : int, entity: Entity = player, run : bool = true, speed_boost : float = 1):
	if entity is Player: entity.disable_controls = true
	var dif = to - entity.global_position.x
	if dif < 0:
		while entity.global_position.x > to:
			entity.move(-1 * speed_boost, run)
			await get_tree().physics_frame
	if dif > 0:
		while entity.global_position.x < to:
			entity.move(1 * speed_boost, run)
			await get_tree().physics_frame
	entity.move(0)
	if entity is Player: entity.disable_controls = false

func get_bounds(entity: Entity):
	var collider : CollisionShape2D = entity.get_children().filter(func (x): return x is CollisionShape2D)[0]
	var gp : Vector2 = entity.global_position
	var tl : Vector2 = collider.shape.get_rect().position
	var br : Vector2 = collider.shape.get_rect().end
	#     left, right, top, bottom, global left, global right, global top, global bottom
	return [tl.x, br.x, tl.y, br.y, tl.x + gp.x, br.x + gp.x, tl.y + gp.y, br.y + gp.y]
#endregion

#region Dialogues
func new_dialogue(dialogue = null, dialogue_resource = null):
	player.disable_controls = true
	var new_dialog_box := DialogueBox.new()
	get_tree().get_current_scene().add_child.call_deferred(new_dialog_box)
	await new_dialog_box.ready
	await get_tree().physics_frame
	if dialogue: await new_dialog_box.begin_dialogue(dialogue)
	elif dialogue_resource: await new_dialog_box.begin_dialogue_from_resource(dialogue_resource)
	new_dialog_box.queue_free()
	player.disable_controls = false
#endregion

#region Camera
func camera_offset(off : Vector2 = Vector2.ZERO):
	player.get_children().filter(func (x): return x is CAM)[0].set_target_offset(off)

func clamp_camera(left : float = -INF, right : float = INF, top : float = -INF, bottom : float = INF, zoom : float = INF, hud_zoom : float = INF):
	var player_cam = player.get_children().filter(func (x): return x is CAM)[0]
	var hud_cam = hud.get_node_or_null("Control/Minimap Container/Minimap/Camera2D")
	if left != -INF:
		player_cam.limit_left = left
		hud_cam.limit_left = left
	if right != INF:
		player_cam.limit_right = right
		hud_cam.limit_right = right
	if top != -INF:
		player_cam.limit_top = top
		hud_cam.limit_top = top
	if bottom != INF:
		player_cam.limit_bottom = bottom
		hud_cam.limit_bottom = bottom
	if zoom != INF: player_cam.zoom = Vector2.ONE*zoom
	if hud_zoom != INF: hud_cam.zoom = Vector2.ONE*hud_zoom
#endregion

#region Levels
func get_lvl(num: int) -> PackedScene:
	return load("res://lvl/%d.tscn" % num)

func open_lvl(num: int):
	var new_lvl_file = QuickScripts.get_lvl(num)
	for this_connection in player_spawned.get_connections(): player_spawned.disconnect(this_connection.callable)
	await fade_out()
	get_tree().change_scene_to_packed(new_lvl_file)

func fade_in(): if pause_menu.is_node_ready(): await pause_menu.fade.fade_in()
func fade_out(): if pause_menu.is_node_ready(): await pause_menu.fade.fade_out()
#endregion
