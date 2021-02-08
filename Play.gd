extends  Button
onready var state = get_node("/root/Level Night")

func _pressed():
	get_tree().change_scene("res://Levels/World(Night).tscn")
