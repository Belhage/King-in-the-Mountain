extends TileMapLayer
class_name DirtMap


var grid_toughness : Array

signal tile_destroyed(tile_type : TILE_TYPES)

enum TILE_TYPES {
	GRASS,
	DIRT,
	STONE,
	COPPER,
	IRON,
	DIAMOND
}


func _ready() -> void:
	var rect := get_used_rect()
	
	#init toughness grid
	for x in rect.end.x:
		grid_toughness.append([])
		for y in rect.end.y:
			grid_toughness[x].append(0) # Set a starter value for each position
	
	#get toughness value
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var data = get_cell_tile_data(Vector2i(x,y))
			if data:
				grid_toughness[x][y] = data.get_custom_data("toughness")


func get_drilled(drill_pos : Vector2, strength : int) :
	var vec2i_pos = local_to_map(drill_pos)
	decrease_toughness(strength, vec2i_pos)


func decrease_toughness(value: int, pos: Vector2i) -> void:
	print("dig at ", pos)
	grid_toughness[pos.x][pos.y] -= value
	if(grid_toughness[pos.x][pos.y] <= 0):
		#tile_destroyed.emit(get_cell_tile_data(pos).get_custom_data("tile type"))
		erase_cell(pos)
		
