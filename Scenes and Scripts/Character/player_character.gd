extends CharacterBody2D
class_name PlayerCharacter

@onready var drill_sprite: AnimatedSprite2D = $"Drill Sprite"

@onready var down_drill_ray: RayCast2D = $"Down Drill Ray"
@onready var right_drill_ray: RayCast2D = $"Right Drill Ray"
@onready var left_drill_ray: RayCast2D = $"Left Drill Ray"


@export var SPEED = 800.0
@export var JUMP_VELOCITY = -1000.0


@export var drill_wait_time : float = 2.0

var current_drill_wait_time : float = 0.0

@export var energy_drain : float = 1.0
@export var drill_power : int = 1
@export var inventory_size : int = 10
@export var energy_capacity : float = 100
@export var current_energy : float = 50

var ready_to_drill : bool = true
var charging : bool = false

# Upgradeable stats
enum UPGRADE_STATS {
	DRILL_POWER,
	INVENTORY_SIZE,
	ENERGY_CAPACITY
}


signal dig_at_pos(pos : Vector2, power : int)
signal no_more_energy
signal update_energy(new_energy : float)

func _process(delta: float) -> void:
	
	if charging :
		current_energy = min(current_energy + energy_drain * 10 * delta, energy_capacity)
	else :
		current_energy -= energy_drain * delta
		if current_energy < 0 :
			energy_runout()
	
	update_energy.emit(current_energy)
	
	if not ready_to_drill :
		current_drill_wait_time -= delta
		if current_drill_wait_time < 0 :
			ready_to_drill = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("Move Up") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_just_pressed("Move Up"):
		velocity.y = JUMP_VELOCITY
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction :  = Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	

	
	if is_on_floor() and is_zero_approx(direction):
		
		if Input.is_action_pressed("Move Down") and velocity.y == 0:
			if Input.is_action_just_pressed("Move Down"): 
				drill_sprite.play("Dig Down")
			drill_down()
		else :
			drill_sprite.play("Idle")
			
	
	
	move_and_slide()
	
	if is_on_wall():
		#if Input.is_action_just_pressed("Move Right") :
		if Input.is_action_pressed("Move Right") :
			drill_sprite.flip_h = false
			drill_sprite.play("Dig Right")
		elif Input.is_action_pressed("Move Left") :
			drill_sprite.flip_h = true
			drill_sprite.play("Dig Right")
			
		if direction == 1 :
			drill_right()
		elif direction == -1 :
			drill_left()
			
	elif direction > 0 :
		drill_sprite.flip_h = false
		drill_sprite.play("Go Right")
	elif direction < 0 :
		drill_sprite.flip_h = true
		drill_sprite.play("Go Right")


func player_upgraded(stat : UPGRADE_STATS, value, _blue, _pink, _orange) :
	if stat == UPGRADE_STATS.DRILL_POWER :
		drill_power += value
		print("Drill upgraded : ", drill_power)
	if stat == UPGRADE_STATS.ENERGY_CAPACITY :
		energy_capacity += value
		print("Energy upgraded : ", energy_capacity)
	if stat == UPGRADE_STATS.INVENTORY_SIZE :
		inventory_size += value
		print("Inventory upgraded : ", inventory_size)
	

func energy_runout() :
	no_more_energy.emit()

func drill_down() :
	
	#print(down_drill_ray.get_collider())
	#print(down_drill_ray.get_collision_point())
	if ready_to_drill :
		dig_at_pos.emit(down_drill_ray.get_collision_point() + Vector2(0, 0.2), drill_power)
		ready_to_drill = false
		current_drill_wait_time = drill_wait_time


func drill_right() :
	if ready_to_drill :
		dig_at_pos.emit(right_drill_ray.get_collision_point()  + Vector2(0.2, 0), drill_power)
		ready_to_drill = false
		current_drill_wait_time = drill_wait_time


func drill_left() :
	if ready_to_drill :
		dig_at_pos.emit(left_drill_ray.get_collision_point() + Vector2( - 0.2, 0), drill_power)
		ready_to_drill = false
		current_drill_wait_time = drill_wait_time
