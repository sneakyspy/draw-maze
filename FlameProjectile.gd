extends KinematicBody2D
onready var col = $CollisionShape2D
export var angle : float = 0
var projectile_velocity = 10

func _process(delta: float) -> void:
	var collided = move_and_collide(Vector2(cos(angle)*projectile_velocity, sin(angle)*projectile_velocity))
	if collided:		queue_free()
