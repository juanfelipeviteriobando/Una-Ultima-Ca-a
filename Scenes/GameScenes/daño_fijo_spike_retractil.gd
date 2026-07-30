extends Node2D

@onready var timer = $Timer
@export var pequeño:Vector2
@export var grande:Vector2
var arriba := false


func _ready():
	$AnimatedSprite2D.play("default")
	timer.start()


func _on_timer_timeout():
	if arriba:
		bajar()
	else:
		subir()

	arriba = !arriba


func subir():
	var tween = create_tween()
	tween.tween_property(
		self,
		"scale",
		grande,
		0.1
	)


func bajar():
	var tween = create_tween()
	tween.tween_property(
		self,
		"scale",
		pequeño,
		0.1
	)


func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D.Dañar(body)
