extends CharacterBody2D
@export var waypoints:Array[Marker2D]
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var current_Index:int=0

func _physics_process(delta: float) -> void:
	var MinDistance:float=5
	var targetPosition=waypoints[current_Index].global_position
	var direction=targetPosition-global_position
	if direction.length()<MinDistance:{
		
		current_Index=1
	}
	velocity=direction.normalized()*SPEED
	move_and_slide()
