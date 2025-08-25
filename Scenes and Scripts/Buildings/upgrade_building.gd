extends Node2D
class_name UpgradeBuilding

var world : World

@export var stat_to_increase : PlayerCharacter.UPGRADE_STATS

#@export var cost_of_pink_at_level : Array[int]
#@export var cost_of_blue_at_level : Array[int]
#@export var cost_of_orange_at_level : Array[int]

@export var cost_and_stat_increase_at_level : Array[UpgradeResource] = [UpgradeResource.new()]

#@export var increase_at_level : Array[int]

@export var interaction_area : Area2D
@export var upgrade_banner : Panel
@export var upgrade_banner_text : TextEdit

var current_level : int = 0

var considering_purchase : bool = false


signal upgrade_purchased(stat_type : PlayerCharacter.UPGRADE_STATS, value)


func _ready() -> void:
	interaction_area.body_entered.connect(show_available_upgrade)
	interaction_area.body_exited.connect(hide_available_upgrade)


func show_available_upgrade(player : PlayerCharacter) :
	considering_purchase = true
	player.charging = true
	upgrade_banner.show()
	upgrade_banner_text.text = "Price of upgrade :
								%d pinkies
								%d blues
								%d oranges" %[cost_and_stat_increase_at_level[current_level].pink_cost, cost_and_stat_increase_at_level[current_level].blue_cost, cost_and_stat_increase_at_level[current_level].orange_cost]
	#upgrade_banner_text.text = "Price of upgrade : \n
								#%d pinkies \n
								#%d blues \n
								#%d oranges" %[1,4,2]
	#print("body entered")


func hide_available_upgrade(player : PlayerCharacter) :
	considering_purchase = false
	player.charging = false
	upgrade_banner.hide()


func can_afford(level : int) -> bool:
	if world.blue_gems < cost_and_stat_increase_at_level[current_level].blue_cost :
		return false
	if world.orange_gems < cost_and_stat_increase_at_level[current_level].orange_cost :
		return false
	if world.pink_gems < cost_and_stat_increase_at_level[current_level].pink_cost :
		return false
	
	return true


func _unhandled_input(event: InputEvent) -> void:
	if considering_purchase and event.is_action_pressed("Purchase Upgrade") and can_afford(current_level):
		upgrade_purchased.emit(stat_to_increase, cost_and_stat_increase_at_level[current_level].stat_increase, cost_and_stat_increase_at_level[current_level].blue_cost, cost_and_stat_increase_at_level[current_level].pink_cost, cost_and_stat_increase_at_level[current_level].orange_cost)
		current_level += 1
		if current_level == len(cost_and_stat_increase_at_level) :
			var new_upgrade := UpgradeResource.new()
			new_upgrade.blue_cost = ceili(cost_and_stat_increase_at_level[current_level - 1].blue_cost * 1.3)
			new_upgrade.pink_cost = ceili(cost_and_stat_increase_at_level[current_level - 1].pink_cost * 1.3)
			new_upgrade.orange_cost = ceili(cost_and_stat_increase_at_level[current_level - 1].orange_cost * 1.3)
			new_upgrade.stat_increase = floori(cost_and_stat_increase_at_level[current_level - 1].stat_increase * 1.3)
			
			cost_and_stat_increase_at_level.append(new_upgrade)
