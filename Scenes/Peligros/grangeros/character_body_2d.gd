extends CharacterBody2D
@export var waypoints:Array[Marker2D]
@export var agent: NavigationAgent2D
@export var persigueJugador:bool=false
<<<<<<< HEAD
@export var TimerFollowPath: Timer
const SPEED = 180.0
=======
@export var SPEED = 100.0
const JUMP_VELOCITY = -400.0
>>>>>>> d0d9f94f8552d5a3c1ed4923ee3552b13ad94652
var current_Index:int=0
var player
func _ready():
	player=get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	var MinDistance:float=5

	if agent.is_navigation_finished():
		current_Index+=1
		if current_Index>=waypoints.size():
			current_Index=0
	
	var direction=agent.get_next_path_position()-global_position
	velocity=direction.normalized()*SPEED
	move_and_slide()



func _on_timer_timeout() -> void:
	if persigueJugador==true:
		agent.target_position=player.global_position
	elif persigueJugador==false:
			agent.target_position=waypoints[current_Index].global_position
