extends CharacterBody2D

@export var waypoints: Array[Marker2D]
@export var velocidad: float = 100.0
@export var distancia_llegada: float = 10.0
@export var NavigationAgent: NavigationAgent2D
@export var area: Area2D 
var indice_actual: int = 0
func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _physics_process(delta):
	if waypoints.is_empty():
		return

	var objetivo = waypoints[indice_actual].global_position
	look_at(objetivo)
	var siguiente_punto = NavigationAgent.get_next_path_position()
	var direccion = (siguiente_punto - global_position).normalized()
	velocity = direccion * velocidad
	move_and_slide()

	# Cuando llega al punto, pasa al siguiente
	if global_position.distance_to(objetivo) < distancia_llegada:
		indice_actual += 1

		# Volver al primer punto al terminar
		if indice_actual >= waypoints.size():
			indice_actual = 0
			


func _on_area_2d_body_entered(body: Node2D) -> void:
	area.Dañar(body)


func _on_timer_timeout() -> void:
	NavigationAgent.target_position = waypoints[indice_actual].global_position
