extends Node2D

signal spawn_selector

var limit: int
var columns: int
var rows: int 
var index: int = 0
var swap_mode: int
var right_position: int

var invalid_positions: Array[int]
var current_level_set: Array
var pieces: Array
var is_restarting: bool = false
var is_moving: bool = false

@export var label: Label
@onready var piece_instance = preload("res://Entities/Pieces/Pieces.tscn")

func _ready():
	global_position = Global.start_position
	Global.piece_handler = self
	setup_game()


func _physics_process(_delta):
	label.text = str(invalid_positions)
	inputs()


func setup_game():
	rows = Global.rows
	columns = Global.columns
	
	for r in rows:
		var invalid: = columns * (r + 1) - 1
		invalid_positions.append(invalid)
		for c in columns:
			var piece = piece_instance.instantiate()
			piece.position = Vector2(c * 120 , r * 120)
			piece.scale = Vector2(0.7, 0.7)
			add_child(piece)
			
			pieces.append(piece)
	
	current_level_set = Global.level_set
	swap_mode = Global.swap_mode
	
	if Global.level_set != null:
		for i in range(min(pieces.size(), current_level_set.size())):
			pieces[i].set_color(current_level_set[i])
	else:
		for i in range(min(pieces.size(), Global.mock_level_set.size())):
			pieces[i].set_color(Global.mock_level_set[i])
	
	right_position = pieces.size() / rows
	limit = pieces.size() - rows
	spawn_selector.emit()
	

func inputs(): 
	if Input.is_action_just_pressed("right"):
		check_movement(1)

	if Input.is_action_just_pressed("left"):
		check_movement(-1)

	if Input.is_action_just_pressed("up"):
		check_movement(-right_position)

	if Input.is_action_just_pressed("down"):
		check_movement(right_position)

	if Input.is_action_just_pressed("action") and Global.game_manager.moves_left > 0:
		if is_restarting:
			return
		Global.game_manager.moves_left -= 1
		Global.player_moves.append(index)
		swap_pieces(swap_mode)
		
		if Global.game_manager.moves_left == 0:
			Global.game_manager.finish_level.emit()
			return
			


func rewind():
	is_restarting = true
	
	var last_index = index
	
	var indexes: Array = Global.player_moves
	indexes.reverse()
	
	for i in range((indexes.size())):
		await get_tree().create_timer(0.1).timeout
		index = indexes[i]
		await get_tree().create_timer(0.1).timeout
		swap_pieces(0)
	
	Global.player_moves.clear()
	index = last_index
	is_restarting = false


func change_position(x, y):
	global_position = Vector2(215.5 + (120 * x), 75.5 + (120 * y))


func remove_pieces():
	for i in range(pieces.size()):  
		pieces[i].queue_free()
	invalid_positions.clear()
	pieces.clear()


func swap_pieces(mode: int):
	#Posição inicial das peças
	
	var piece1 = pieces[index]
	var piece2 = pieces[index + 1]
	var piece3 = pieces[index + right_position]
	var piece4 = pieces[index + right_position + 1]
	
	var piece_to_move: Array = [piece1, piece2, piece3, piece4]
	var pieces_to_swap: Array
	
	var clockwise: Array = [piece2, piece4, piece1, piece3]
	var counter_clockwise: Array = [piece3, piece1, piece4, piece2]
	var cross: Array = [piece4, piece3, piece2, piece1]
	
	match mode:
		0:
			pieces_to_swap = clockwise 
		1: 
			pieces_to_swap = counter_clockwise
		2: 
			pieces_to_swap = cross

	is_moving = true
	var tween = create_tween().set_parallel(true)
	
	for i in range(min(piece_to_move.size(), pieces_to_swap.size())):
		tween.tween_property(piece_to_move[i], 'global_position', pieces_to_swap[i].global_position, 0.1)
	
	swap_piece_index(pieces_to_swap)

	await tween.finished
	if tween.finished:
		tween.kill()
	is_moving = false


func swap_piece_index(swap_index: Array):
	if swap_mode != 2:
		swap_index.reverse()
	
	pieces[index] = swap_index[0] 
	pieces[index + 1] = swap_index[1] 
	pieces[index + right_position] = swap_index[2]
	pieces[index + right_position + 1] = swap_index[3]


func check_movement(value: int):
	var inverted_position: int = columns - 2
	if value > 1 or value < -1:
		if index + value >= limit:
			index = index + -value * (rows - 2)
			return
		if index + value < 0:
			index = index + -value * (1 + (rows - 3))
			return
			
	if index + value in invalid_positions or index + value < 0:
		if value > 0:
			print("index: ", index," inverted pos: ",  inverted_position," sum: ", index - inverted_position)
			index = index - inverted_position 
			return
		index = index + inverted_position
		return
	index += value
