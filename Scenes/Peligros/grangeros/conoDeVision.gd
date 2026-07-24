extends Area2D

signal player_detected(player)
signal player_lost(player)

func _on_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		player_detected.emit(body)


func _on_body_exited(body):
	print(body)
	if body.is_in_group("Player"):
		player_lost.emit(body)
		
