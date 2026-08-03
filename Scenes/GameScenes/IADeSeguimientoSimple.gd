extends CharacterBody2D

@export var waypoints: Array[Marker2D]
@export var velocidad: float = 100.0
@export var distancia_llegada: float = 10.0

@export var area: Area2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var indice_actual := 0

@export var NavigationAgent: NavigationAgent2D
@export var area: Area2D 
var indice_actual: int = 0

func _ready() -> void:
	$AnimatedSprite2D.play("default")

	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = distancia_llegada

	if !waypoints.is_empty():
		nav_agent.target_position = waypoints[indice_actual].global_position

func _physics_process(delta: float) -> void:
	if waypoints.is_empty():
		return

	# Si llegó al waypoint
	if nav_agent.is_navigation_finished():
		indice_actual = (indice_actual + 1) % waypoints.size()
		nav_agent.target_position = waypoints[indice_actual].global_position
		return

	# Obtener el siguiente punto del camino
	var siguiente_punto = nav_agent.get_next_path_position()

	var direccion = (siguiente_punto - global_position).normalized()


	velocity = direccion * velocidad

	if velocity.length() > 0:
		look_at(global_position + velocity)

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	area.Dañar(body)


func _on_timer_timeout() -> void:
	NavigationAgent.target_position = waypoints[indice_actual].global_position
