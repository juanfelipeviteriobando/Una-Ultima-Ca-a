extends Node
@export_category("Movimiento")
@export var Player: CharacterBody2D
@export_category("animaciones")
@export var Animations: AnimationPlayer
@export_category("Efectos")
@export var WalkParticles:GPUParticles2D
var Current_State: STATE = STATE.IDLE
@export var variable:variables
var scale_tween
var Dash_Direction := Vector2.ZERO
enum STATE {
	IDLE,
	MOVING,
	Dash
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _on_player_dash() -> void:
	if not variable.can_dash:
		return
	if Current_State == STATE.Dash:
		return
	variable.can_dash = false
	Current_State = STATE.Dash
	
	Dash_Direction = Player.Input_Dir.normalized()
	await get_tree().create_timer(variable.dash_duration).timeout
	Dashcooldown()
func Dashcooldown():
	Current_State = STATE.IDLE
	await get_tree().create_timer(variable.dash_cooldown).timeout
	variable.can_dash = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Current_State != STATE.Dash:
		if Player.Input_Dir == Vector2.ZERO:
			Current_State = STATE.IDLE
		else:
			Current_State = STATE.MOVING
	match Current_State:
		STATE.IDLE:
			estado_Idle(delta)
		STATE.MOVING:
			estado_Moving(delta)
		STATE.Dash:
			estado_Dash(delta)


func estado_Idle(delta: float) -> void:
	WalkParticles.emitting = false
	Animations.play("Idle")
	Player.velocity = Player.velocity.move_toward(Vector2.ZERO, Player.Friction * delta)

func estado_Moving(delta: float) -> void:
	MoveCaracteristics()
	Player.velocity = Player.velocity.move_toward(Player.Input_Dir * Player.Speed, Player.Aceleration * delta)

func estado_Dash(delta: float) -> void:
	MoveCaracteristics()
	Player.velocity = Dash_Direction* Player.Speed*variable.dash_Multiplier


func MoveCaracteristics():
	scale_tween = create_tween()
	scale_tween.tween_property(Player, "scale", Vector2(1.0, 1.0), 0.2)
	WalkParticles.emitting = true
	Animations.play("Moving")
