extends Area2D

@export var reserva_agua := 100.0
@export var velocidad_llenado := 10.0

var jugador: CharacterBody2D = null

func _process(delta):
	if jugador == null:
		return

	if reserva_agua <= 0:
		hide()
		$CollisionShape2D.disabled = true
		return

	var cantidad = velocidad_llenado * delta

	# No entregar más agua de la que queda.
	cantidad = min(cantidad, reserva_agua)
	if jugador==null:
		return
	jugador.ActualWater += cantidad
	jugador.WaterChange.emit(jugador.ActualWater)

	reserva_agua -= cantidad

func _on_body_entered(body):
	if body.is_in_group("Player"):
		jugador = body

func _on_body_exited(body):
	if body == jugador:
		jugador = null
