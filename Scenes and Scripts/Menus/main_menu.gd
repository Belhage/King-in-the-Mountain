extends Control


const WORLD = preload("res://Scenes and Scripts/Main Scene/world.tscn")
@onready var about_section: CanvasLayer = $"About Section"

func _on_texture_button_pressed() -> void:
	about_section.hide()


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)


func _on_about_button_pressed() -> void:
	about_section.show()
