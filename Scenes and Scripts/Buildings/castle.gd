extends Node2D
class_name Castle

var world : World


@onready var interaction_area: Area2D = $"Interaction Area"
@onready var upgrade_banner: Panel = $Panel
@onready var upgrade_banner_text: TextEdit = $Panel/TextEdit


@export var blue_cost : int = 20
@export var pink_cost : int = 20
@export var orange_cost : int = 20

var considering_ending_game : bool = false


signal end_game_goal_reached


func show_available_upgrade(player : PlayerCharacter) :
	considering_ending_game = true
	player.charging = true
	upgrade_banner.show()
	upgrade_banner_text.text = "Price of upgrade :
								%d pinkies
								%d blues
								%d oranges" %[pink_cost, blue_cost, orange_cost]
	#upgrade_banner_text.text = "Price of upgrade : \n
								#%d pinkies \n
								#%d blues \n
								#%d oranges" %[1,4,2]
	#print("body entered")


func can_afford() -> bool:
	if world.blue_gems < blue_cost :
		print(world.blue_gems, blue_cost)
		print("not enough blue")
		return false
	if world.orange_gems < orange_cost :
		print("not enough orange")
		return false
	if world.pink_gems < pink_cost :
		print("not enough pink")
		return false
	
	return true


func _unhandled_input(event: InputEvent) -> void:
	if considering_ending_game and event.is_action_pressed("Purchase Upgrade") and can_afford():
		end_game()
		print("end game")


func end_game() :
	end_game_goal_reached.emit()


func _on_interaction_area_body_entered(body: PlayerCharacter) -> void:
	considering_ending_game = true
	show_available_upgrade(body)


func _on_interaction_area_body_exited(body: PlayerCharacter) -> void:
	considering_ending_game = false
	upgrade_banner.hide()
	body.charging = false
