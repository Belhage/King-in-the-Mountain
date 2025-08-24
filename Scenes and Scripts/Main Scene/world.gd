extends Node2D
class_name World

@export var player : PlayerCharacter
@export var map : DirtMap
@onready var start_position: Node2D = $"Start Position"

@onready var drill_upgrade: UpgradeBuilding = $"Drill Upgrade"
@onready var energy_upgrade: UpgradeBuilding = $"Energy Upgrade"
@onready var inventory_upgrade: UpgradeBuilding = $"Inventory Upgrade"

@onready var hud: HUD = %HUD


func _ready() -> void:
	player.dig_at_pos.connect(map.get_drilled)
	player.no_more_energy.connect(energy_runout)
	player.update_energy.connect(hud.update_energy)
	
	
	drill_upgrade.upgrade_purchased.connect(upgrade_purchased)
	
	
	


var inventory : int = 0
var inventory_max : int = 100

var blue_gems : int = 0
var pink_gems : int = 0
var orange_gems : int = 0


func upgrade_purchased(_stat, _increase, blue, pink, orange) :
	blue_gems -= blue
	pink_gems -= pink
	orange_gems -= orange


func energy_runout() :
	blue_gems = 0
	pink_gems = 0
	orange_gems = 0
	player.position = start_position.position


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
