extends Node2D
class_name Level

@export var player_spawn_position := Vector2(0,0)
@export var objective_point : String = "9.9."

func _ready() -> void:
	AudioServer.set_bus_volume_db(QuickScripts.audio_music_bus, linear_to_db(0.1))
	prepare_map()
	QuickScripts.fade_in()
	QuickScripts.spawn()
	if not QuickScripts.pause_menu.is_node_ready(): await QuickScripts.pause_menu.ready
	QuickScripts.pause_menu.rebuild_tree(objective_point)

# to be overwritten
func prepare_map():
	pass
