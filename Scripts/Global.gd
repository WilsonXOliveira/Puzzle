extends Node

var game_manager
var piece_handler
var selector_handler
var pause_screen

var level_index: int
var level_list_index: int
var rows: int = 3
var columns: int = 3
var level_moves: int = 2
var swap_mode: int = 0
var player_moves: Array[int]
var match_colors: Array = [0,1,2]
var level_set: Array 
var start_position: Vector2 = Vector2(455.5 , 195.5)

var mocK_level_set: Array = [0,0,0,1,1,1,2,2,2]

var levels_completed: Array[Array]
