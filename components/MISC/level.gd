extends Node2D
class_name Level

@export var player_spawn_position := Vector2(0,0)
@onready var fade = Fade.new()

func _ready() -> void:
	AudioServer.set_bus_volume_db(QuickScripts.audio_music_bus, linear_to_db(0.1))
	add_child.call_deferred(fade)
	prepare_map()
	fade.duration = 2
	fade.layer = 2
	await fade.ready
	fade.fade_in()
	QuickScripts.spawn()

# to be overwritten
func prepare_map():
	pass
