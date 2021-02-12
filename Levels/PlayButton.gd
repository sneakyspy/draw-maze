extends Button
onready var tilemap_editor = get_node("../../TileMapEditorScrollContainer/PanelContainer/Tilemap")

func _pressed():
	var thisgame = preload("res://Levels/WorldGame.tscn").instance()
	get_node("/root").add_child(thisgame)
	var tilemap_game = thisgame.get_node("Tilemap")
	for x in range(2560/64):
		for y in range(3072/64):
			tilemap_game.set_cell(x, y, tilemap_editor.get_cell(x, y))
	get_tree().current_scene = thisgame


