extends Node2D
class_name World

@export var player : PlayerCharacter
@export var map : DirtMap


func _ready() -> void:
	player.dig_at_pos.connect(map.get_drilled)


var inventory : int = 0
var inventory_max : int = 100

var blue_gems : int = 0
var pink_gems : int = 0
var orange_gems : int = 0
