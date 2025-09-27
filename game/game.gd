extends Node2D
class_name Game

#@onready var audio_listener_2d: AudioListener2D = $pacman/AudioListener2D

@onready var _pacman: CharacterBody2D = $pacman
@onready var camera: Camera2D = $pacman/Camera2D
@onready var _tilemap: TileMapLayer = %tilemap

@onready var _start: Marker2D = %start
@onready var _end: Marker2D = %end

var _astar_grid = AStarGrid2D.new()

#jumpscare
@onready var jumpcare: Node = $jumpcare
@onready var jumpscare_sprite: Sprite2D = $jumpcare/Sprite2D
@onready var jumpscare_background: ColorRect = $"jumpcare/jumpscare-background"
@onready var jumpscare_1: AudioStreamPlayer = $jumpcare/Jumpscare94984
@onready var jumpscare_2: AudioStreamPlayer = $jumpcare/SqueakyJumpscare2102254
@onready var jumpscare_3: AudioStreamPlayer = $jumpcare/AscendingJumpscare102061
@onready var jumpscare_array = [jumpscare_1, jumpscare_2, jumpscare_3]


func _ready() -> void:
	var _rect: Rect2 = Rect2i()
	#audio_listener_2d.make_current()
	_rect.position = Vector2(_start.position)
	_rect.end = Vector2(_end.position)
	_astar_grid.region = _rect
	_astar_grid.cell_size = Vector2(16, 16)
	_astar_grid.offset = _astar_grid.cell_size / 2
	_astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar_grid.update()
	
	jumpscare_sprite.visible = false
	jumpscare_background.visible = false
	
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
	


func _on_pacman_jumpsscare() -> void:
	var numr = (randi() % 3)
	print(numr)
	get_tree().paused = true
	
	jumpscare_sprite.global_position = camera.global_position
	jumpscare_background.visible = true
	jumpscare_sprite.visible = true
	
	jumpscare_array[numr].play()
