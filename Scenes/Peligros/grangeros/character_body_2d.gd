extends CharacterBody2D
@export var waypoints:Array[Marker2D]
@export var agent: NavigationAgent2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var current_Index:int=0

func _physics_process(delta: float) -> void:
	var MinDistance:float=5

	if agent.is_navigation_finished():
		current_Index+=1
		if current_Index>=waypoints.size():
			current_Index=0
		agent.target_position=waypoints[current_Index].global_position
	
	var direction=agent.get_next_path_position()-global_position
	velocity=direction.normalized()*SPEED
	move_and_slide()
