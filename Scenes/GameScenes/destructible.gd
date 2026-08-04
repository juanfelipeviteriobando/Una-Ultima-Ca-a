extends Node2D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
func Noquear():
	desactivar_objeto()

func destruir(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.StateMachine.Current_State == body.StateMachine.STATE.Dash:
			desactivar_objeto()
		else:
			body.get_node("AnimationPlayer2").play("daño")


func desactivar_objeto() -> void:
	# Ocultar objeto
	$"..".visible = false
	$CollisionShape2D.disabled = true
	$CollisionPolygon2D.disabled = true
	# Desactivar colisiones de este objeto
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true

	# Opcional: eliminarlo después de un tiempo
	queue_free()
