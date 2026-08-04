extends Control

@export var BUTTONINICIO: TextureButton
@export var BUTTONSALIR: TextureButton

@export var MusicRepeat: AudioStreamOggVorbis
# Ruta de la escena del juego
@export var escena_juego: String = "res://Scenes/NIVEL/Nivel.tscn"

func _ready() -> void:
	BUTTONINICIO.pressed.connect(_on_button_inicio_pressed)
	BUTTONSALIR.pressed.connect(_on_button_salir_pressed)

func _on_button_inicio_pressed() -> void:
	get_tree().change_scene_to_file(escena_juego)

func _on_button_salir_pressed() -> void:
	get_tree().quit()


func _on_texture_button_focus_entered() -> void:
	$Clicked.play()


func _on_texture_button_mouse_entered() -> void:
	$ButtonSounds.play()


func _on_texture_button_2_mouse_entered() -> void:
	$ButtonSounds.play()


func _on_texture_button_2_focus_entered() -> void:
	$Clicked.play()


func _on_music_finished() -> void:
	$Music.stream = MusicRepeat
	$Music.play()
	$Music.finished.disconnect(_on_music_finished)
