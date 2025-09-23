extends TileMapLayer


var _astar_grid: AStarGrid2D = AStarGrid2D.new()


func _ready() -> void:
	_astar_grid.region = Rect2i(0, 0, 10, 10)
	_astar_grid.cell_size = Vector2(64, 64)
	_astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar_grid.update()
	
	for i in get_used_cells():
		var _tile_data: TileData = get_cell_tile_data(i)
		if _tile_data.get_custom_data("wall"):
			_astar_grid.set_point_solid(i, true)
	_show_path()


func _show_path() -> void:
	var _path = _astar_grid.get_id_path(Vector2i(0, 0), Vector2i(9, 9))
	for i in _path:
		set_cell(i, 1, Vector2i(2, 0))
	print(_path)


func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		if _event.is_pressed() and _event.button_index == MOUSE_BUTTON_LEFT:
			print(_event.position)
