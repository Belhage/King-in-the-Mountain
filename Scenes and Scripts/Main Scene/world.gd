extends Node2D


@export var player : PlayerCharacter
@export var map : DirtMap


func _ready() -> void:
	player.dig_at_pos.connect(map.get_drilled)


var inventory : int = 0
var inventory_max : int = 100

var blue_gems : int = 0
var pink_gems : int = 0
var orange_gems : int = 0


func _on_world_tile_map_tile_destroyed(tile_type: DirtMap.TILE_TYPES) -> void:
	match(tile_type):
		DirtMap.TILE_TYPES.DIRT:
			pass
		DirtMap.TILE_TYPES.BLUE:
			blue_gems+=1
			inventory+=1
			%HUD.blues = blue_gems
			%HUD.inventory = inventory
		DirtMap.TILE_TYPES.PINK:
			pink_gems+=1
			inventory+=1
			%HUD.pinks = pink_gems
			%HUD.inventory = inventory
		DirtMap.TILE_TYPES.ORANGE:
			orange_gems+=1
			inventory+=1
			%HUD.oranges = orange_gems
			%HUD.inventory = inventory
