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

var Granjero

@export_category("Boost")
@export var BoostScript: Node
var LoseBoostPoint: float = 0.2
var LoseDashPoint: float = 3.0

@export_category("WaterBar")
@export var WaterScript: Node
var WaterAmount: float = 50.0
enum STATE {
	IDLE,
	MOVING,
	Dash
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Granjero = get_tree().get_first_node_in_group("Enemigo")
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
	if BoostScript.ActualBoost <= BoostScript.MinBoost:
		Granjero.persigueJugador = true
		Player.velocity = Vector2.ZERO
		Current_State = STATE.IDLE
		Animations.play("Idle")
		return
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
	BoostScript.LoseBoost(LoseBoostPoint)
	Player.velocity = Player.velocity.move_toward(Player.Input_Dir * Player.Speed, Player.Aceleration * delta)

func estado_Dash(delta: float) -> void:
	MoveCaracteristics()
	BoostScript.LoseBoost(LoseDashPoint)
	Player.velocity = Dash_Direction* Player.Speed*variable.dash_Multiplier


func MoveCaracteristics():
	WalkParticles.emitting = true
	Animations.play("Moving")

func BoostLosted():
	pass
