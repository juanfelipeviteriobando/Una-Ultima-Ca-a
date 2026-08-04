extends Area2D

@export var nodo_objetivo: Node
@export var activar: bool = true
func _ready() -> void:
	if nodo_objetivo:
		nodo_objetivo.process_mode = Node.PROCESS_MODE_INHERIT if !activar else Node.PROCESS_MODE_DISABLED
		nodo_objetivo.visible = !activar

func _on_body_entered(body):
	if nodo_objetivo:
		nodo_objetivo.process_mode = Node.PROCESS_MODE_INHERIT if activar else Node.PROCESS_MODE_DISABLED
		nodo_objetivo.visible = activar

		if nodo_objetivo is Area2D:
			nodo_objetivo.monitoring = activar
			nodo_objetivo.monitorable = activar

	queue_free()
