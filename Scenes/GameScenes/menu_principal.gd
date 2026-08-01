extends Control

@export var BUTTONINICIO: TextureButton
@export var BUTTONSALIR: TextureButton

# Ruta de la escena del juego
@export var escena_juego: String = "res://Scenes/GameScenes/test.tscn"

func _ready() -> void:
	BUTTONINICIO.pressed.connect(_on_button_inicio_pressed)
	BUTTONSALIR.pressed.connect(_on_button_salir_pressed)

func _on_button_inicio_pressed() -> void:
	get_tree().change_scene_to_file(escena_juego)

func _on_button_salir_pressed() -> void:
	get_tree().quit()
