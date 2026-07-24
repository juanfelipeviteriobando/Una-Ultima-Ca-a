extends Node
@export var Player: CharacterBody2D
@export var Animations: AnimationPlayer

var Current_State: STATE = STATE.IDLE

enum STATE {
	IDLE,
	MOVING
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Player.Input_Dir != Vector2.ZERO:
		Current_State = STATE.MOVING
	elif Player.Input_Dir == Vector2.ZERO:
		Current_State = STATE.IDLE
	match Current_State:
		STATE.IDLE:
			Animations.play("Idle")
			Player.velocity = Player.velocity.move_toward(Vector2.ZERO, Player.Friction * delta)
		STATE.MOVING:
			Animations.play("Moving")
			Player.velocity = Player.velocity.move_toward(Player.Input_Dir * Player.Speed, Player.Aceleration * delta)
