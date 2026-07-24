extends CharacterBody2D
@export var waypoints:Array[Marker2D]
@export var agent: NavigationAgent2D
@export var persigueJugador:bool=false
@export var SPEED = 100.0
var current_Index:int=0
var player
func _ready():
	player=get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:

	if agent.is_navigation_finished():
		current_Index+=1
		if current_Index>=waypoints.size():
			current_Index=0
		if persigueJugador==false:
			agent.target_position=waypoints[current_Index].global_position
	
	var direction=agent.get_next_path_position()-global_position
	velocity=direction.normalized()*SPEED
	move_and_slide()



func _on_timer_timeout() -> void:
	if persigueJugador==true:
		agent.target_position=player.global_position
