extends CharacterBody2D
@export var waypoints:Array[Marker2D]
@export var agent: NavigationAgent2D
@export var persigueJugador:bool=false
const SPEED = 80.0
const JUMP_VELOCITY = -400.0
var current_Index:int=0
var wait: bool = false
var player
func _ready():
	player=get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if wait == true:
		return
	if agent.is_navigation_finished():
		current_Index+=1
		$Timer2.start()
		wait = true
		if current_Index>=waypoints.size():
			current_Index=0
		
	
	var direction=agent.get_next_path_position()-global_position
	velocity=direction.normalized()*SPEED
	move_and_slide()



func _on_timer_timeout() -> void:
	if persigueJugador==false:
			agent.target_position=waypoints[current_Index].global_position
	if persigueJugador==true:
		agent.target_position=player.global_position



func _on_area_2d_body_entered(body: Node2D) -> void:
	persigueJugador=true # Replace with function body.


func _on_timer_2_timeout() -> void:
	wait = false


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	persigueJugador=false
