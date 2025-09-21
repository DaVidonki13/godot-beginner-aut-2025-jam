extends TileMapLayer


var astar_grid = AStarGrid2D.new()


func _ready() -> void:
	astar_grid.region = Rect2i(0, 0, 32, 32)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()
