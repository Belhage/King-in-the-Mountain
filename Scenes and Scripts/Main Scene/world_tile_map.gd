extends TileMapLayer

var grid : Array

func _ready() -> void:
	var rect := get_used_rect()
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var data = get_cell_tile_data(Vector2i(x,y))
			if data:
				grid[x][y] = data.get_custom_data("toughness")

func decrease_toughness(value: int, pos: Vector2i) -> void:
	grid[pos.x][pos.y] -= value
	if(grid[pos.x][pos.y] <= 0):
		erase_cell(pos)
