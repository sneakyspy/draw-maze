extends Button
onready var state = get_node("../../..")

func _pressed():
	state.selected_tool = 1
