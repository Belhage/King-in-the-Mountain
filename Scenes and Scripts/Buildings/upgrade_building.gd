extends Node2D
class_name UpgradeBuilding

var world : World

@export var stat_to_increase : PlayerCharacter.UPGRADE_STATS

@export var cost_of_pink_at_level : Array[int]
@export var cost_of_blue_at_level : Array[int]
@export var cost_of_orange_at_level : Array[int]
@export var increase_at_level : Array[int]

@export var interaction_area : Area2D
@export var upgrade_banner : Panel

var current_level : int = 0

var considering_purchase : bool = false


signal upgrade_purchased(stat_type : PlayerCharacter.UPGRADE_STATS, value)


func _ready() -> void:
	interaction_area.body_entered.connect(show_available_upgrade)
	interaction_area.body_exited.connect(hide_available_upgrade)


func show_available_upgrade(_player) :
	upgrade_banner.show()
	#print("body entered")


func hide_available_upgrade(_player) :
	upgrade_banner.hide()


func can_afford(level : int) -> bool:
	if world.blue_gems < cost_of_blue_at_level[level] :
		return false
	if world.orange_gems < cost_of_orange_at_level[level] :
		return false
	if world.pink_gems < cost_of_pink_at_level[level] :
		return false
	
	return true


func _unhandled_input(event: InputEvent) -> void:
	if considering_purchase and event.is_action_pressed("Purchase Upgrade") and can_afford(current_level):
		upgrade_purchased.emit(stat_to_increase, increase_at_level[current_level])
		current_level += 1
