extends Actor

const MAX_SPEED = 20000
var input_vector = Vector2.ZERO
var Velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		Velocity = input_vector
	else:
		Velocity = Vector2.ZERO
	
	move_and_slide(Velocity * delta * MAX_SPEED)
