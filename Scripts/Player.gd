extends Actor

export var SPEED = 100.0
var state = MOVE
var direction = Vector2.RIGHT
enum{
	IDLE
	MOVE
	FIRE
}

func _process(delta: float) -> void:
	match state:
		IDLE:
			pass
		MOVE:
			pass
		FIRE:
			pass

func move(delta):
	var position = Node2D.position
	position += direction * SPEED * delta
