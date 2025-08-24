extends CharacterBody2D
class_name PlayerCharacter

@onready var test_figure: AnimatedSprite2D = $"Test Figure"

@onready var down_drill_ray: RayCast2D = $"Down Drill Ray"
@onready var right_drill_ray: RayCast2D = $"Right Drill Ray"
@onready var left_drill_ray: RayCast2D = $"Left Drill Ray"


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0


@export var drill_wait_time : float = 2.0

var current_drill_wait_time : float = 0.0

@export var energy_drain : float = 1.0
@export var drill_power : int = 1
@export var inventory_size : int = 10
@export var energy_capacity : float = 100

var ready_to_drill : bool = true


# Upgradeable stats
enum UPGRADE_STATS {
	DRILL_POWER,
	INVENTORY_SIZE,
	ENERGY_CAPACITY
}


signal dig_at_pos(pos : Vector2, power : int)

func _process(delta: float) -> void:
	if not ready_to_drill :
		current_drill_wait_time -= delta
		if current_drill_wait_time < 0 :
			ready_to_drill = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Move Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Move Down") and is_on_floor() and velocity.y == 0:
		drill_down()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction :  = Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0 :
		test_figure.flip_h = false
		test_figure.play("Go Right")
	elif direction < 0 :
		test_figure.flip_h = true
		test_figure.play("Go Right")

	
	if is_on_floor() and is_zero_approx(direction) :
		test_figure.play("Idle")
	
	move_and_slide()
	
	if is_on_wall() :
		if direction == 1 :
			drill_right()
		elif direction == - 1 :
			drill_left()


func drill_down() :
	test_figure.play("Dig Down")
	print(down_drill_ray.get_collider())
	print(down_drill_ray.get_collision_point())
	dig_at_pos.emit(down_drill_ray.get_collision_point(), drill_power)


func drill_right() :
	test_figure.flip_h = false
	test_figure.play("Dig Right")
	dig_at_pos.emit(right_drill_ray.get_collision_point(), drill_power)


func drill_left() :
	test_figure.flip_h = true
	test_figure.play("Dig Right")
	dig_at_pos.emit(left_drill_ray.get_collision_point(), drill_power)
