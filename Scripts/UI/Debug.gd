extends Control

@onready var xcor = $XCord
@onready var ycor = $YCord

@onready var row = $Row
@onready var column = $Column

var x_cord: float
var y_cord: float


func _on_button_pressed():
	Global.rows = row.value 
	Global.columns = column.value
	
	if row.value and column.value >= 0:
		Global.piece_handler.remove_pieces()
		Global.piece_handler.setup_game()
		

	x_cord = xcor.value
	y_cord = ycor.value
	
	Global.piece_handler.change_position(x_cord, y_cord)
	
