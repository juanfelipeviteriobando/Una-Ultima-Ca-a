extends Node2D

signal player_detected(player)
signal player_lost(player)

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_detected.emit(body)


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	player_lost.emit(body)
