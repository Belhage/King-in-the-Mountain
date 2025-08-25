extends CanvasLayer
class_name HUD

@onready var energy_bar: ProgressBar = %"Energy Bar"
@onready var energy_label: Label = %"Energy Label"

@export var inventory : int = 0:
	set(value):
		inventory = value
		inventory_text()

@export var inventory_max : int = 100:
	set(value):
		inventory_max = value
		inventory_text()

@export var blues : int = 0 :
	set(value):
		blues = value
		%blue.text = ": "+str(value)
@export var pinks : int = 0:
	set(value):
		pinks = value
		%pink.text = ": "+str(value)
@export var oranges : int = 0:
	set(value):
		oranges = value
		%orange.text = ": "+str(value)
		
func inventory_text() -> void:
	%inventory.text = "Inventory: "+str(inventory)+"/"+str(inventory_max)

func update_energy(new_energy : float) :
	#print(new_energy)
	energy_bar.value = new_energy
	energy_label.text = "%d/%d" %[round(new_energy), energy_bar.max_value]
	if new_energy < energy_bar.max_value * 0.1 :
		energy_bar

func energy_capacity_upgraded(_stat, increase, blue, pink, orange) :
	energy_bar.max_value += increase


func setup(energy_capacity) :
	energy_bar.max_value = energy_capacity


func _on_texture_button_toggled(toggled_on: bool) -> void:
	Sound.game_muted = toggled_on
