extends Position2D
var offset = 20
onready var lantern = $Lanturn
onready var world = get_node("../../..")
onready var new_projectile_scene = load("res://FlameProjectile.tscn")

var refuel_time = 0
var fuel_count = 3
var refuel_delay = 1
var extinguished = 0

func _process(delta: float) -> void:
	var angle = get_angle_to(get_global_mouse_position())
	var off_x = cos(angle) * offset
	var off_y = sin(angle) * offset
	lantern.offset = Vector2( off_x, off_y)

	refuel_time += delta
	if not extinguished and refuel_time > refuel_delay:
		fuel_count = fuel_count + 1
		refuel_time = 0
	
	if fuel_count > 0 and Input.is_action_just_pressed("Click"):
		var new_projectile = new_projectile_scene.instance()
		new_projectile.global_position = global_position + lantern.offset
		new_projectile.angle = angle
		world.add_child(new_projectile)
		refuel_time = 0
		fuel_count = fuel_count - 1
		if fuel_count == 0:
			extinguished = 1
