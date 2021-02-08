extends Button
onready var state = get_node("../../..")

func _pressed() -> void:
	state.selected_tool = 2
