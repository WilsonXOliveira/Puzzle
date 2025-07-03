extends Control

@onready var classic: TextureButton = $Classic
@onready var hard: TextureButton = $Hard
@onready var infinite: TextureButton = $Infinite

signal enable_buttons
signal disable_buttons

func _ready() -> void:
	enable_buttons.connect(on_enabled_buttons)
	disable_buttons.connect(on_disabled_buttons)
	
func _on_classic_pressed() -> void:
	pass # Replace with function body.


func _on_hard_pressed() -> void:
	pass # Replace with function body.


func _on_infinite_pressed() -> void:
	pass # Replace with function body.


func on_enabled_buttons():
	print("enabled")
	classic.disabled = false
	hard.disabled = false
	infinite.disabled = false


func on_disabled_buttons():
	print("disabled")
	classic.disabled = true
	hard.disabled = true
	infinite.disabled = true
