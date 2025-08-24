extends TileMapLayer

var grid_toughness : Array

signal tile_destroyed(tile_type : TILE_TYPES)

enum TILE_TYPES {
	GRASS,
	DIRT,
	COPPER,
	IRON,
	DIAMOND
}

func _ready() -> void:
	var rect := get_used_rect()
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var data = get_cell_tile_data(Vector2i(x,y))
			if data:
				grid_toughness[x][y] = data.get_custom_data("toughness")


func decrease_toughness(value: int, pos: Vector2i) -> void:
	grid_toughness[pos.x][pos.y] -= value
	if(grid_toughness[pos.x][pos.y] <= 0):
		erase_cell(pos)
		tile_destroyed.emit(get_cell_tile_data(pos).get_custom_data("tile type"))
