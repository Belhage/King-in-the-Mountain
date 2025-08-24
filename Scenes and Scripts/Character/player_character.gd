extends CharacterBody2D
class_name PlayerCharacter

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0


# Upgradeable stats
enum UPGRADE_STATS {
	DRILL_POWER,
	INVENTORY_SIZE,
	ENERGY_CAPACITY
}



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Move Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
