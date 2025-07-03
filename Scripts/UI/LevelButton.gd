extends TextureButton

var level_index: int
var level_list_index: int
@export var rows: int
@export var columns: int
@export var swap_mode: int = 0
@export var level_moves: int = 0
@export var level_set: Array [int]
@export var match_colors: Array [int]
@export var x_cord: float
@export var y_cord: float

@export var is_completed: bool = false

const button_texture = preload("res://Sprites/Background/LevelButton.png")
const finished_texture = preload("res://Sprites/PieceColors/Blue.png")

func _ready():
	if is_completed:
		texture_normal = null
		return
	texture_normal = button_texture


func _on_pressed():
	Global.level_index = level_index
	Global.level_list_index = level_list_index
	Global.rows = rows
	Global.columns = columns
	Global.level_set = level_set
	Global.swap_mode = swap_mode
	Global.match_colors = match_colors
	Global.level_moves = level_moves
	Global.start_position = Vector2(215.5 + (120 * x_cord), 75.5 + (120 * y_cord))
	
	get_tree().change_scene_to_file("res://Levels/Set3x3.tscn")

func change_texture():
	if is_completed:
		texture_normal = null
