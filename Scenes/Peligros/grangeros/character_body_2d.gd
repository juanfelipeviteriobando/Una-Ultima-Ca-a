extends CharacterBody2D
@export var waypoints:Array[Marker2D]
@export var agent: NavigationAgent2D
@export var persigueJugador:bool=false
var is_waiting: bool = false
const SPEED = 80.0
const JUMP_VELOCITY = -400.0
var current_Index:int=0
var player
func _ready():
	player=get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	var direction= agent.get_next_path_position() - global_position
	var Distance = direction.length()
	
	if is_waiting == true:
		return
	
	if agent.is_navigation_finished():
		current_Index += 1
		velocity = Vector2.ZERO
		$Timer2.start()
		is_waiting = true
		
		if current_Index>=waypoints.size():
			current_Index=0
		
	

	velocity=direction.normalized()*SPEED
	move_and_slide()



func _on_timer_timeout() -> void:
	if persigueJugador==false:
			var Target_position = waypoints[current_Index].global_position
			agent.target_position=Target_position
	if persigueJugador==true:
		agent.target_position=player.global_position


func _on_timer_2_timeout() -> void:
	is_waiting = false
