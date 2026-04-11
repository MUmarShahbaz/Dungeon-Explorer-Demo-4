extends Node

func get_player():
	var player = get_tree().get_first_node_in_group("players")
	while player == null:
		await get_tree().physics_frame
		player = get_tree().get_first_node_in_group("players")
	return player

func get_hud():
	var hud = get_tree().get_first_node_in_group("hud")
	while hud == null:
		await get_tree().physics_frame
		hud = get_tree().get_first_node_in_group("hud")
	return hud

func new_dialogue(dialogue = null, dialogue_resource = null):
	var player : Player = await get_player()
	player.disable_controls = true
	var new_dialog_box := DialogueBox.new()
	add_child.call_deferred(new_dialog_box)
	await new_dialog_box.ready
	await get_tree().physics_frame
	if dialogue: await new_dialog_box.begin_dialogue(dialogue)
	elif dialogue_resource: await new_dialog_box.begin_dialogue_from_resource(dialogue_resource)
	new_dialog_box.queue_free()
	player.disable_controls = false

func clamp_camera(left : float = -INF, right : float = INF, top : float = -INF, bottom : float = INF, zoom : float = INF, hud_zoom : float = INF):
	var player = await get_player()
	var hud = await get_hud()
	await get_tree().physics_frame
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

func get_bounds(entity: Entity):
	var collider : CollisionShape2D = entity.get_children().filter(func (x): return x is CollisionShape2D)[0]
	var gp : Vector2 = entity.global_position
	var tl : Vector2 = collider.shape.get_rect().position
	var br : Vector2 = collider.shape.get_rect().end
	#     left, right, top, bottom, global left, global right, global top, global bottom
	return [tl.x, br.x, tl.y, br.y, tl.x + gp.x, br.x + gp.x, tl.y + gp.y, br.y + gp.y]

func get_lvl(num: int) -> PackedScene:
	return load("res://lvl/%d.tscn" % num)
