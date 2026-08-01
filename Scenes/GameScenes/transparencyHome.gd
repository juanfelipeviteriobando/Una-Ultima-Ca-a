extends Area2D

@onready var techo := $TileMapLayer

var tween: Tween

func _on_body_entered(body):
	if body.is_in_group("Player"):
		cambiar_transparencia(0.25) # 25% visible

func _on_body_exited(body):
	if body.is_in_group("Player"):
		cambiar_transparencia(1.0) # Totalmente visible

func cambiar_transparencia(alpha: float):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(techo, "modulate:a", alpha, 0.3)
