extends Node2D
class_name World

@export var player : PlayerCharacter
@export var map : DirtMap
@onready var start_position: Node2D = $"Start Position"

@onready var drill_upgrade: UpgradeBuilding = $"Drill Upgrade"
@onready var energy_upgrade: UpgradeBuilding = $"Energy Upgrade"
@onready var inventory_upgrade: UpgradeBuilding = $"Inventory Upgrade"
@onready var castle: Castle = $Castle

@onready var hud: HUD = %HUD
@onready var end_game_screen: CanvasLayer = $"End Game Screen"


func _ready() -> void:
	player.dig_at_pos.connect(map.get_drilled)
	player.no_more_energy.connect(energy_runout)
	player.update_energy.connect(hud.update_energy)
	
	
	drill_upgrade.upgrade_purchased.connect(upgrade_purchased)
	energy_upgrade.upgrade_purchased.connect(upgrade_purchased)
	inventory_upgrade.upgrade_purchased.connect(upgrade_purchased)
	
	
	drill_upgrade.upgrade_purchased.connect(player.player_upgraded)
	energy_upgrade.upgrade_purchased.connect(player.player_upgraded)
	inventory_upgrade.upgrade_purchased.connect(player.player_upgraded)
	
	drill_upgrade.world = self
	energy_upgrade.world = self	
	inventory_upgrade.world = self
	castle.world = self
	
	castle.end_game_goal_reached.connect(end_of_game)
	
	energy_upgrade.upgrade_purchased.connect(hud.energy_capacity_upgraded)
	
	hud.inventory_max = inventory_max
	hud.setup(player.energy_capacity)
	update_hud()

var inventory : int = 0
var inventory_max : int = 8

var blue_gems : int = 0
var pink_gems : int = 0
var orange_gems : int = 0


func end_of_game() :
	end_game_screen.show()


func upgrade_purchased(_stat, _increase, blue, pink, orange) :
	blue_gems -= blue
	pink_gems -= pink
	orange_gems -= orange
	inventory -= blue + pink + orange
	update_hud()


func energy_runout() :
	blue_gems = 0
	pink_gems = 0
	orange_gems = 0
	player.position = start_position.position
	player.current_energy = 10
	update_hud()


func _on_world_tile_map_tile_destroyed(tile_type: DirtMap.TILE_TYPES) -> void:
	match(tile_type):
		DirtMap.TILE_TYPES.DIRT:
			pass
		DirtMap.TILE_TYPES.BLUE:
			if inventory < inventory_max:
				blue_gems += 1
				inventory += 1
		DirtMap.TILE_TYPES.PINK:
			if inventory < inventory_max:
				pink_gems += 1
				inventory += 1
		DirtMap.TILE_TYPES.ORANGE:
			if inventory < inventory_max:
				orange_gems += 1
				inventory += 1
	update_hud()
			


func update_hud() :
	hud.blues = blue_gems
	hud.oranges = orange_gems
	hud.pinks = pink_gems
	hud.inventory = inventory
