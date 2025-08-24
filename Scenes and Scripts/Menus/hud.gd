extends CanvasLayer

@export var inventory : int = 0
@export var inventory_max : int = 100

@export var blues : int = 0
@export var pinks : int = 0
@export var oranges : int = 0

func _process(delta: float) -> void:
	get_node("/root/")
	pass
