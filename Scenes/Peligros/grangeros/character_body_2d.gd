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
@export var distanciadeataque := 1
@export_category("tiempos")
@export var tiempo_Noqueaut:float =6
@export var tiempo_espera:=1
#@export_category("limites de estado")
@export var tiempo_max_estado: float = 10

@export_category("Musica")
@export var LevelMusic: AudioStreamPlayer
@export var ChaseMusic: AudioStreamPlayer2D
@export var MusicRepeat: AudioStream

var tiempo_busqueda := 0.0

var nivel_sospecha:int = 0
var posicion_investigar:Vector2

var current_Index:int=0
var wait: bool = false
var player
func _ready():
	player=get_tree().get_first_node_in_group("Player")
	$Node2D/Area2D/CollisionShape2D.disabled=true

func _physics_process(delta: float) -> void:
	if persigueJugador == true:
		var MusicTween1 = create_tween()
		var MusicTween2 = create_tween()
		MusicTween1.tween_property(LevelMusic, "volume_db", -80.0, 0.5)
		MusicTween2.tween_property(ChaseMusic, "volume_db", 0.0, 0.1)
	if persigueJugador == false:
		var MusicTween1 = create_tween()
		var MusicTween2 = create_tween()
		MusicTween1.tween_property(LevelMusic, "volume_db", 0.0, 0.5)
		MusicTween2.tween_property(ChaseMusic, "volume_db", -80.0, 0.5)


		pass
	if wait == true&&persigueJugador==false:
		return
	
		# Control de tiempo de estados temporales
	if estado_actual != EstadoIA.PERSIGUIENDO \
	and estado_actual != EstadoIA.PATRULLANDO \
	and estado_actual != EstadoIA.NOQUEADO:

		tiempo_estado += delta

		if tiempo_estado >= tiempo_max_estado:
			cambiar_estado(EstadoIA.PATRULLANDO)
			persigueJugador = false
			wait = false
			nivel_sospecha = 0
			agent.target_position = waypoints[current_Index].global_position

	
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
	var distanciaaljugador = global_position.distance_to(player.global_position)
	var limite:bool=true
	if distanciaaljugador<=distanciadeataque:
		limite=false
		matar(player)
	if estado_actual==EstadoIA.PATRULLANDO:
		limite=true
	velocity=direction.normalized()*SPEED*int(limite)
	move_and_slide()
	



func _on_timer_timeout() -> void:
	if persigueJugador==false:
			if waypoints.size() <=0:
				return
			agent.target_position=waypoints[current_Index].global_position
	if persigueJugador==true:
		var MusicTween1 = create_tween()
		var MusicTween2 = create_tween()
		MusicTween1.tween_property(LevelMusic, "volume_db", -80.0, 0.5)
		MusicTween2.tween_property(ChaseMusic, "volume_db", 0.0, 0.1)
		agent.target_position=player.global_position
		



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body!=null and body.is_in_group("Player"):

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
				cambiar_estado(EstadoIA.PERSIGUIENDO)

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
	PERSIGUIENDO,
	NOQUEADO
}

var estado_actual = EstadoIA.PATRULLANDO
var tiempo_estado := 0.0
func cambiar_estado(nuevo_estado: EstadoIA):
	if estado_actual != nuevo_estado:
		estado_actual = nuevo_estado
		tiempo_estado = 0.0

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
			await get_tree().create_timer(tiempo_espera).timeout
			wait = false


		# Segunda vez: investigar cerca del jugador
		2:
			wait = false
			cambiar_estado(EstadoIA.INVESTIGANDO)
			posicion_investigar = player.global_position + Vector2(40, 40)
			agent.target_position = posicion_investigar
			
			await get_tree().create_timer(tiempo_espera).timeout


		# Tercera vez: persecución
		3:
			cambiar_estado(EstadoIA.PERSIGUIENDO)
			persigueJugador = true
			wait = false

func Noquear():
	cambiar_estado(EstadoIA.NOQUEADO)
	await get_tree().create_timer(tiempo_Noqueaut).timeout
	cambiar_estado(EstadoIA.PATRULLANDO)

func matar(body: Node2D) -> void:
	if body.is_in_group("Player") and is_inside_tree():
		var boost = body.get_node("BoostScript")
		if boost.ActualBoost <= boost.MinBoost:
			await get_tree().create_timer(0.5).timeout
			body.morir()


func ataque() -> void:
	if estado_actual != EstadoIA.PERSIGUIENDO:
		$Node2D.hide()
		return

	$Node2D.look_at(player.global_position)
	$Node2D.show()

	var shape_node = $Node2D/Area2D/CollisionShape2D

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape_node.shape
	query.transform = shape_node.global_transform

	# Opcional: excluir al propio granjero
	query.exclude = [self]

	# Usa la máscara del CollisionShape/Area si quieres respetar capas
	query.collision_mask = $Node2D/Area2D.collision_mask

	var resultados = get_world_2d().direct_space_state.intersect_shape(query)

	for resultado in resultados:
		var cuerpo = resultado.collider
		
		if cuerpo.is_in_group("Player"):
			$Node2D/Area2D.Dañar(cuerpo)

	await get_tree().create_timer(0.1).timeout
	
	$Node2D.hide()


func _on_audio_stream_player_2d_finished() -> void:
	ChaseMusic.stream = MusicRepeat
