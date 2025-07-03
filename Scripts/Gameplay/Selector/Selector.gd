extends Node2D
@onready var sprites = $Arrow

func _ready():
	var tween = get_tree().create_tween()
	sprites.modulate.a = 0.0
	
	tween.tween_property(sprites, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	scale = Vector2 (0.7,0.7)
