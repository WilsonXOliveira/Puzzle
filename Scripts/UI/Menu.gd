extends Control

@onready var background_left: Sprite2D = $Menu/MenuLeft
@onready var background_right: Sprite2D = $Menu/MenuRight
@onready var mode_selection: Control = $"Mode Selection"

@onready var menu_itens: Label = $Menu/Label

@onready var start: Button = $Menu/Start
@onready var quit: Button = $Menu/Quit

var left_panel_original_position: Vector2
var right_panel_original_position: Vector2

var left_panel_moving_position: Vector2 = Vector2(-877, 0) 
var right_panel_moving_position: Vector2 = Vector2(877, 0)

func _ready() -> void:
	left_panel_original_position = background_left.position
	right_panel_original_position = background_right.position

func _on_start_pressed():
	start.disabled = true
	quit.disabled = true
	move_menu_background(left_panel_moving_position, right_panel_moving_position)
	fade_menu()

func _on_quit_pressed():
	get_tree().quit()


func move_menu_background(left_position, right_position):
	var move_bg = create_tween().set_parallel(true).bind_node(self).set_trans(Tween.TRANS_SINE)
	
	move_bg.tween_property(background_left, "position", left_position, 0.7)
	move_bg.tween_property(background_right, "position", right_position, 0.7)
	
	await move_bg.finished
	
	var tween = get_tree().create_tween()
	tween.tween_property(mode_selection, "modulate:a", 1.0, 0.3)
	mode_selection.enable_buttons.emit()
	#get_tree().change_scene_to_file("res://UI/LevelSelect.tscn")


func fade_menu():
	
	var fade_tween = create_tween().set_parallel(true).bind_node(self).set_trans(Tween.TRANS_SINE)
	
	fade_tween.tween_property(menu_itens, "modulate:a", 0, 0.5)
	fade_tween.tween_property(start, "modulate:a", 0, 0.5)
	fade_tween.tween_property(quit, "modulate:a", 0, 0.5)
	
	await fade_tween.finished
	fade_tween.kill()
