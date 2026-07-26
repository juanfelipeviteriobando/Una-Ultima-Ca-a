extends CharacterBody2D
@export var waypoints:Array[Marker2D]
@export var agent: NavigationAgent2D
@export var persigueJugador:bool=false
var SPEED = 80.0
@export_category("velocidades")
@export var NormalSpeed:float = 80.0
@export var Max_Speed = 120.0

@export_category("Vision")
@export var angulo_busqueda := 50.0 # grados a cada lado
@export var velocidad_busqueda := 2.0

var tiempo_busqueda := 0.0

var nivel_sospecha:int = 0
var posicion_investigar:Vector2

var current_Index:int=0
var wait: bool = false
var player
func _ready():
	player=get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	
	if wait == true&&persigueJugador==false:
		return
	var objetivo_rotation: float
	var direccion:float
	if persigueJugador:
		# Mira directamente al jugador
		objetivo_rotation = ($vision.global_position.direction_to(player.global_position)).angle()
	else:
		# Dirección hacia donde camina
		direccion = (agent.get_next_path_position() - global_position).angle()

	# Movimiento de búsqueda izquierda-derecha
	tiempo_busqueda += delta
	var offset = deg_to_rad(angulo_busqueda) * sin(tiempo_busqueda * velocidad_busqueda)
	if !persigueJugador:
		objetivo_rotation = direccion + offset

	$vision.rotation = lerp_angle(
		$vision.rotation,
		objetivo_rotation,
		6.0 * delta
	)

	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		current_Index+=1
		if persigueJugador == false:
			wait = true
			$Timer2.start()
		elif persigueJugador == true:
			cambiar_estado(EstadoIA.PERSIGUIENDO)
			wait = false
			$Timer2.stop()
		if current_Index>=waypoints.size():
			current_Index=0
		
	
	var direction=agent.get_next_path_position()-global_position
	if persigueJugador == true:
		SPEED = Max_Speed
	else:
		SPEED = NormalSpeed
	velocity=direction.normalized()*SPEED
	move_and_slide()



func _on_timer_timeout() -> void:
	if persigueJugador==false:
			if waypoints.size() <=0:
				return
			agent.target_position=waypoints[current_Index].global_position
	if persigueJugador==true:
		agent.target_position=player.global_position
		



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):

		var shape = body.get_node("CollisionShape2D")
		var objetivo = shape.global_position

		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			objetivo
		)

		query.exclude = [
			get_rid(),
			$vision/Area2D.get_rid(),
			$vision/Area2D2.get_rid()
		]

		query.collision_mask = 1|4
		query.collide_with_bodies = true
		query.collide_with_areas = false

		var result = get_world_2d().direct_space_state.intersect_ray(query)

		if not result.is_empty():
			if result["collider"] == body:
				persigueJugador = true

func _on_timer_2_timeout() -> void:
	wait = false


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(1).timeout
	persigueJugador=false
	nivel_sospecha=0
	
enum EstadoIA {
	PATRULLANDO,
	SOSPECHANDO,
	INVESTIGANDO,
	PERSIGUIENDO
}

var estado_actual = EstadoIA.PATRULLANDO
var tiempo_estado := 0.0
func cambiar_estado(nuevo_estado):
	if estado_actual != nuevo_estado:
		estado_actual = nuevo_estado
		tiempo_estado = 0

func _on_vision_player_suspicious(player: Variant) -> void:
	if persigueJugador:
		return

	nivel_sospecha += 1

	match nivel_sospecha:
		0:
			cambiar_estado(EstadoIA.PATRULLANDO)
		# Primera vez que lo ve
		1:
			wait = true
			cambiar_estado(EstadoIA.SOSPECHANDO)
			await get_tree().create_timer(5).timeout
			wait = false


		# Segunda vez: investigar cerca del jugador
		2:
			wait = false
			cambiar_estado(EstadoIA.INVESTIGANDO)
			posicion_investigar = player.global_position + Vector2(40, 40)
			agent.target_position = posicion_investigar
			
			await get_tree().create_timer(5).timeout


		# Tercera vez: persecución
		3:
			EstadoIA.PERSIGUIENDO
			persigueJugador = true
			wait = false
