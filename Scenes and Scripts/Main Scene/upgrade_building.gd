extends Node2D
class_name UpgradeBuilding

@export var stat_to_increase : PlayerCharacter.UPGRADE_STATS

@export var cost_at_level : Array[int]
@export var increase_at_level : Array[int]

@export var interaction_area : Area2D
@export var upgrade_banner : Node2D

var considering_purchase : bool = false

func _ready() -> void:
	interaction_area.body_entered.connect(show_available_upgrade)
	


func show_available_upgrade(_player) :
	upgrade_banner.show()


func hide_available_upgrade(_player) :
	upgrade_banner.hide()


#func _unhandled_input(event: InputEvent) -> void:
	#if considering_purchase and event.is_action_pressed("Purchase Upgrade") :
		#
