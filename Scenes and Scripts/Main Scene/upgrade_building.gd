extends Node2D
class_name UpgradeBuilding

@export var stat_to_increase : PlayerCharacter.UPGRADE_STATS

@export var cost_at_level : Array[int]
@export var increase_at_level : Array[int]

@export var interaction_area : Area2D

func _ready() -> void:
	pass
	


func show_available_upgrade() :
	pass
