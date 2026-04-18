extends Node2D
class_name Level

@export var player_spawn_position := Vector2(0,0)

func _ready() -> void:
	AudioServer.set_bus_volume_db(QuickScripts.audio_music_bus, linear_to_db(0.1))
	prepare_map()
	QuickScripts.fade_in()
	QuickScripts.spawn()

# to be overwritten
func prepare_map():
	pass
