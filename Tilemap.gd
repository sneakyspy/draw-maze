extends TileMap
onready var state = get_node("../../../..")
onready var tile_map_scroll = get_node("../..")
onready var hbox = get_node("../../../hBoxContainer")
var is_pressed : int = 1




func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		var coord_x = event.position[0] + tile_map_scroll.scroll_horizontal
		var coord_y = event.position[1] + tile_map_scroll.scroll_vertical - hbox.rect_size[1]
		var cell_x = int(coord_x/ 64);
		var cell_y = int(coord_y/ 64);
		if (coord_y > 0):
			if event is InputEventMouseButton:
				if event.is_pressed():
					if event.button_index == 1: 
						is_pressed = 1
					elif event.button_index == 2:
						is_pressed = -1
				else:
					is_pressed = 0
			if is_pressed == 1:
				set_cell(cell_x, cell_y, state.selected_tool)
				
			elif is_pressed == -1:
				set_cell(cell_x, cell_y, -1)
