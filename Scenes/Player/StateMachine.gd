extends Node
@export var Player: CharacterBody2D
@export var Animations: AnimationPlayer
@export var WalkParticles:GPUParticles2D
var Current_State: STATE = STATE.IDLE

var scale_tween

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
			WalkParticles.emitting = false
			Animations.play("Idle")
			Player.velocity = Player.velocity.move_toward(Vector2.ZERO, Player.Friction * delta)
		STATE.MOVING:
			scale_tween = create_tween()
			scale_tween.tween_property(Player, "scale", Vector2(1.0, 1.0), 0.4)
			WalkParticles.emitting = true
			Animations.play("Moving")
			Player.velocity = Player.velocity.move_toward(Player.Input_Dir * Player.Speed, Player.Aceleration * delta)
