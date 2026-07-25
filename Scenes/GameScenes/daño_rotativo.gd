extends Node2D
@export var area:Area2D
@export var velocidad_rotacion: float = 2.0

func _process(delta):
	rotation += velocidad_rotacion * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	area.Dañar(body)
