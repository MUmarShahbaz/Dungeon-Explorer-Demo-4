extends TileMapLayer

var cells = {
	"breakable_floors" : Vector2i(15, 6),
	"spikes_in" : Vector2i(11, 8),
	"spikes_out" : Vector2i(12, 8)
}

var TRAPS_CONTAINER

func _ready() -> void:
	TRAPS_CONTAINER = Node2D.new()
	TRAPS_CONTAINER.name = "Traps"
	get_tree().get_current_scene().add_child.call_deferred(TRAPS_CONTAINER)
	
	for cell in get_used_cells():
		match get_cell_atlas_coords(cell):
			cells.breakable_floors:
				create_area(cell, Vector2(0, -18), Vector2(54, 48), "break_floor")
			cells.spikes_in:
				create_area(cell, Vector2(0, 12), Vector2(48, 24), "activate_spike")
			cells.spikes_out:
				create_area(cell, Vector2(0, 12), Vector2(48, 24), "activate_spike")

func create_area(cell, local_position, size, handler):
	var shape    : RectangleShape2D = RectangleShape2D.new()
	var collider : CollisionShape2D = CollisionShape2D.new()
	var area     : Area2D           = Area2D.new()
	
	shape.size = size
	collider.shape = shape
	area.add_child(collider)
	area.global_position = map_to_local(cell) + local_position
	area.body_entered.connect(Callable(self, handler).bind(area, cell))
	area.set_collision_mask_value(1, false)
	area.set_collision_mask_value(3, true)
	area.set_collision_mask_value(4, true)
	area.name = handler + "(" + str(cell.x) + "," + str(cell.y) + ")"
	
	TRAPS_CONTAINER.add_child.call_deferred(area)

func break_floor(body, floor_piece : Area2D, cell):
	if body is not Player: return
	await get_tree().create_timer(1.5).timeout
	if floor_piece: floor_piece.queue_free()
	set_cell(cell, -1)

func activate_spike(body, spike_piece : Area2D, cell):
	if body is not Player: return
	if get_cell_atlas_coords(cell) == cells.spikes_in:
		await get_tree().create_timer(0.5).timeout
		set_cell(cell, 0, cells.spikes_out, 0)
	for this_body in spike_piece.get_overlapping_bodies():
		if this_body is Entity: (this_body as Entity).die()
	await get_tree().create_timer(1.5).timeout
	set_cell(cell, 0, cells.spikes_in, 0)
