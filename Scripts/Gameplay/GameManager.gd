extends Node

@export var info: Label
var level_list_index: int
var level_index: int
var piece_rows: int
var piece_set: Array
var moves_left: int

signal finish_level
signal restart_level

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_manager = self
	
	finish_level.connect(on_finish_level)
	level_list_index = Global.level_list_index
	moves_left = Global.level_moves
	piece_set = Global.piece_handler.pieces
	piece_rows = Global.piece_handler.rows
	level_index = Global.level_index


func on_finish_level():
	if check_rows(Global.match_colors):
		Global.levels_completed[level_list_index][level_index] = true
		get_tree().change_scene_to_file("res://UI/LevelSelect.tscn")
		return
	Global.piece_handler.rewind()
	moves_left = Global.level_moves


func check_rows(colors_match: Array) -> bool:
	for r in piece_rows:
		@warning_ignore("integer_division")
		var set_size = piece_set.size() / piece_rows
		var initial = set_size * r
		var final = set_size * (r+1)
		var sliced = piece_set.slice(initial, final)
		
		for s in sliced:
			if s.piece_color != colors_match[r]:
				return false
	return true
