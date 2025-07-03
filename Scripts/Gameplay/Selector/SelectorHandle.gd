extends Node

@onready var selector = preload("res://Entities/Selector/Selector.tscn")
@onready var piece_handler = Global.piece_handler
@export var pieces_label: Label

var actual_index: int
var pieces_list: Array
var is_ready: bool = false
var selector_instance

func _ready():
	spawn_selectors()


func _physics_process(_delta):
	pieces_list = piece_handler.pieces
	actual_index = piece_handler.index
	pieces_label.text = str(pieces_list.size(), actual_index)
	if !Global.piece_handler.is_moving and !Global.piece_handler.is_restarting:
		selector_instance.visible = true
		move_selector()
	
	if Global.piece_handler.is_restarting:
		#selector_instance.global_position = pieces_list[0].global_position
		selector_instance.visible = false
	

func spawn_selectors():
	selector_instance = selector.instantiate()
	await get_tree().create_timer(0.3).timeout
	print(pieces_list[0].global_position)
	add_child(selector_instance)


func move_selector():
	if actual_index >= 0 and actual_index < pieces_list.size():  # Verificar se o índice está dentro do alcance
		var piece = pieces_list[actual_index]
		if is_instance_valid(piece) and piece != null:  # Verifica se o objeto é válido e não nulo
			var next_position = piece.global_position
			
			var selector_tween = create_tween()
			selector_tween.tween_property(selector_instance, "global_position", next_position, 0.1)
			await selector_tween.finished
			
			if selector_tween.is_valid():  # Certifica-se de que o tween ainda existe antes de tentar matá-lo
				selector_tween.kill()
