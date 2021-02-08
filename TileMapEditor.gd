extends Control
onready var tilemap = $TileMapEditor

func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	var tile_map_scroll = get_node("TileMapEditorScrollContainer")
	if event is InputEventMouseButton:
		var cell_x = int((event.position[0] + tile_map_scroll.scroll_horizontal)/ 64);
		var cell_y = int((event.position[1] + tile_map_scroll.scroll_vertical)/ 64);
		tilemap.set_cell(cell_x, cell_y, null)
