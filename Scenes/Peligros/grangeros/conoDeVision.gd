extends Node2D

signal player_detected(player)
signal player_suspicious(player)
signal player_lost(player)

var objetivo: Node2D = null
var objetivoDefinitivo: Node2D = null

var puede_detectar := false


# area cercana
func _on_area_2d_body_entered(body: Node2D) -> void:
	objetivoDefinitivo = body
	
	# Le damos tiempo al jugador para reaccionar
	puede_detectar = false
	
	await get_tree().create_timer(2).timeout
	
	if objetivoDefinitivo == body:
		puede_detectar = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if objetivoDefinitivo == body:
		objetivoDefinitivo = null
		puede_detectar = false


# vision lejana
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	objetivo = body


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if objetivo == body:
		objetivo = null
		player_lost.emit(body)

var puede_sospechar := true
@export var tiempo_sospecha := 3.0
var ya_detectado := false

func _process(delta):
	# sospecha que se mueve
	if objetivo&&objetivo.velocity.length() > 5 and puede_sospechar:
		puede_sospechar = false
		
		look_at(objetivo.global_position)
		player_suspicious.emit(objetivo)
		
		await get_tree().create_timer(tiempo_sospecha).timeout
		puede_sospechar = true


	# confirma que se movio
	if objetivoDefinitivo and puede_detectar and not ya_detectado:
		if objetivoDefinitivo.velocity.length() > 5:
			ya_detectado = true
			player_detected.emit(objetivoDefinitivo)
