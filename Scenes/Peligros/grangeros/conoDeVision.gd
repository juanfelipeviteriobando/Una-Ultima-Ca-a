extends Area2D

signal player_detected(player)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_detected.emit(body)
