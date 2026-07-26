extends Area2D
@export var daño:float

func Dañar(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.BoostScript.LoseBoost(daño)
