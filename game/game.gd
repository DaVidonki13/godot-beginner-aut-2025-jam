extends Node2D
class_name Game


@onready var _pacman: CharacterBody2D = %pacman
@onready var camera: Camera2D = $camera
@onready var _tilemap: TileMapLayer = %tilemap

@onready var _start: Marker2D = %start
@onready var _end: Marker2D = %end

var _astar_grid = AStarGrid2D.new()


func _ready() -> void:
	var _rect: Rect2 = Rect2i()
	_rect.position = Vector2(_start.position)
	_rect.end = Vector2(_end.position)
	_astar_grid.region = _rect
	_astar_grid.cell_size = Vector2(16, 16)
	_astar_grid.offset = _astar_grid.cell_size / 2
	_astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar_grid.update()
	
	for i in _tilemap.get_used_cells():
		var _tile_data = _tilemap.get_cell_tile_data(i)
		if _tile_data.get_custom_data("wall"):
			_astar_grid.set_point_solid(i, true)


func get_shortest_path(_start_point: Vector2, _finish_point: Vector2) -> PackedVector2Array:
	_start_point = snapped(_start_point, Vector2(8, 8))
	_finish_point = snapped(_finish_point, Vector2(8, 8))
	_start_point = _tilemap.local_to_map(_start_point)
	_finish_point = _tilemap.local_to_map(_finish_point)
	var _path_ids = _astar_grid.get_id_path(_start_point, _finish_point, true)
	var _path_points = _astar_grid.get_point_path(_start_point, _finish_point, true)
	#DEBUG
	#for i in _path_ids:
		#_tilemap.set_cell(i, 0, Vector2i(22, 2))
	return _path_points


func _on_r_area_2d_body_entered(body: Node2D) -> void:
	if body == _pacman:
		_pacman.global_position = Vector2(-414, 24)
		camera.global_position = Vector2(-414, 24)


func _on_l_area_2d_2_body_entered(body: Node2D) -> void:
	if body == _pacman:
		_pacman.global_position = Vector2(400, 24)
		camera.global_position = Vector2(400, 24)
