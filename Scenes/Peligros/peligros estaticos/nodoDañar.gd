extends Area2D


func Dañar(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("jaja")
