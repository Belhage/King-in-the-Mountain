extends Node2D


@export var player : PlayerCharacter
@export var map : DirtMap


func _ready() -> void:
	player.dig_at_pos.connect(map.get_drilled)


var inventory : int = 0
var inventory_max : int = 100

var gold : int = 0
var gems : int = 0
