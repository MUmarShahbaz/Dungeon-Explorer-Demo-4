extends Node2D
class_name Level

@export var player_spawn_position := Vector2(0,0)
@onready var pause_menu = preload("res://ui/pause_menu.tscn").instantiate()
@onready var fade = Fade.new()

func _ready() -> void:
	QuickScripts.bg_player.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child.call_deferred(pause_menu)
	add_child.call_deferred(fade)
	prepare_map()
	fade.duration = 2
	fade.layer = 2
	await fade.ready
	fade.fade_in()

# to be overwritten
func prepare_map():
	pass
