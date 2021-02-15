extends RigidBody2D
class_name FlamePivotType
	
var lantern_offset = 40
onready var player = get_node("..")
onready var lantern = $Lanturn
onready var animate = $Lanturn/AnimationPlayer
onready var world = get_node("../../..")
onready var new_projectile_scene = load("res://FlameProjectile.tscn")

var refuel_time = 0
var fuel_count = 1
var refuel_delay = 1
var extinguished = 0
var max_fuel = 4

func reignite():
	extinguished = 0

func set_fuel_count(count):
	fuel_count = count
	if fuel_count == 0:
		extinguished = 1
	else:
		extinguished = 0
	animate.set_assigned_animation(_animation_from_fuel_count(fuel_count))

func _animation_from_fuel_count(count) -> String:
	if fuel_count >= 4:
		return "Full"
	elif fuel_count >= 3:
		return "Medium"
	elif fuel_count >= 2:
		return "Medium Low"
	elif fuel_count >= 1:
		return "Low"
	else:
		return "Off"

func _process(delta: float) -> void:
	var angle = player.get_angle_to(get_global_mouse_position())
	var lan_off = Vector2(
		cos(angle) * lantern_offset,
		sin(angle) * lantern_offset)
	global_position = player.global_position + lan_off 

	refuel_time += delta
	if not extinguished and refuel_time > refuel_delay and fuel_count < max_fuel:
		set_fuel_count(fuel_count + 1)
		refuel_time = 0

	if fuel_count > 0 and Input.is_action_just_pressed("Click"):
		var new_projectile = new_projectile_scene.instance()
		new_projectile.global_position = global_position
		new_projectile.angle = angle
		world.add_child(new_projectile)
		refuel_time = 0
		set_fuel_count(fuel_count - 1)
