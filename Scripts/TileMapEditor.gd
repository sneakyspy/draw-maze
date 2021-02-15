extends Control

onready var level_size_x_input = $VBoxContainer/hBoxContainer/Panel/LevelSizeX
onready var level_size_y_input = $VBoxContainer/hBoxContainer/Panel2/LevelSizeY
onready var tilemap_container = $VBoxContainer/TileMapEditorScrollContainer/PanelContainer
onready var tilemap = $VBoxContainer/TileMapEditorScrollContainer/PanelContainer/Tilemap
onready var tile_map_scroll = $VBoxContainer/TileMapEditorScrollContainer

var is_pressed : int = 0
var level_size_x : int = 100
var level_size_y : int = 100
var selected_tool : int = 0 
var player_pos : Vector2 = Vector2(-1,-1)

class ToolSet:
	const FLOOR = 0
	const WALL = 1
	const ENEMY = 2
	const TORCH = 3
	const PLAYER = 4

func resize_editor_tilemap_x(x : int):
	level_size_x = x
	tilemap_container.rect_min_size.x = x * tilemap.cell_size[0]
	tilemap_container.rect_size.x = x * tilemap.cell_size[0]

func resize_editor_tilemap_y(y : int):
	level_size_y = y
	tilemap_container.rect_min_size.y = y * tilemap.cell_size[1]
	tilemap_container.rect_size.y = y * tilemap.cell_size[1]

func _ready() -> void:
	level_size_x_input.text = level_size_x as String
	level_size_y_input.text = level_size_y as String

func _on_LevelSizeX_text_changed(new_text: String) -> void:
	if !new_text.is_valid_integer():
		level_size_x_input.text = level_size_x as String
	else:
		resize_editor_tilemap_x(level_size_x_input.text as int)

func _on_LevelSizeY_text_changed(new_text: String) -> void:
	if !new_text.is_valid_integer():
		level_size_y_input.text = level_size_y as String
	else:
		resize_editor_tilemap_y(level_size_y_input.text as int)

func _on_FloorButton_pressed() -> void:
	selected_tool = ToolSet.FLOOR

func _on_WallButton_pressed() -> void:
	selected_tool = ToolSet.WALL

func _on_EnemyButton_pressed() -> void:
	selected_tool = ToolSet.ENEMY

func _on_TorchButton_pressed() -> void:
	selected_tool = ToolSet.TORCH

func _on_PlayerButton_pressed() -> void:
	selected_tool = ToolSet.PLAYER

func _on_PlayButton_pressed() -> void:
	if player_pos[0] < 0:
		return
	var torchscn = preload("res://Torch.tscn")
	var thisgame = preload("res://Levels/WorldGame.tscn").instance()
	get_node("/root").add_child(thisgame)
	var tilemap_game = thisgame.get_node("Tilemap")
	var player = thisgame.get_node("Actors/Player")
	var objs = thisgame.get_node("Objects")
	var rng = RandomNumberGenerator.new()
	for x in range(-3,level_size_x + 3):
		for y in range(-3, level_size_y + 3):
			if x < 0 or y < 0 or x > level_size_x or y > level_size_y:
				tilemap_game.set_cell(x, y, 1)
			else:
				var v = tilemap.get_cell(x, y)
				if v == ToolSet.WALL or v == ToolSet.FLOOR:
					tilemap_game.set_cell(x, y, v)
				elif v == ToolSet.PLAYER:
					tilemap_game.set_cell(x, y, ToolSet.FLOOR)
					player.global_position = Vector2(
						x * tilemap_game.cell_size[0] + tilemap_game.cell_size[0]/2,
						y * tilemap_game.cell_size[1] + tilemap_game.cell_size[1]/2
					)
				elif v == ToolSet.TORCH:
					tilemap_game.set_cell(x, y, ToolSet.FLOOR)
					var thistorch = torchscn.instance()
					thistorch.global_position = Vector2(
						x * tilemap_game.cell_size[0] + tilemap_game.cell_size[0]/2,
						y * tilemap_game.cell_size[1] + tilemap_game.cell_size[1]/2
					)
					objs.add_child(thistorch)
				else:
					tilemap_game.set_cell(x, y, ToolSet.WALL)
	tilemap_game.update_dirty_quadrants()
	get_tree().current_scene = thisgame
	queue_free()

func _assign_cell_to(cell: Vector2, value: int):
	if value == ToolSet.PLAYER:
		if player_pos[0] > 0:
			_assign_cell_to(player_pos, ToolSet.FLOOR)
		player_pos = cell
	tilemap.set_cell(cell[0], cell[1], value)

func _on_PanelContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		var cell = tilemap.world_to_map(event.position)
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == 1: 
					is_pressed = 1
				elif event.button_index == 2:
					is_pressed = -1
			else:
				is_pressed = 0

		if is_pressed == 1:
			_assign_cell_to(cell, selected_tool)
		elif is_pressed == -1:
			_assign_cell_to(cell, 0)
