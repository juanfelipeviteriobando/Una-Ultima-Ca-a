extends CharacterBody2D

@export var Sprite: Sprite2D
@export var Speed: float = 150.0
@export var Friction: float = 1200.0
@export var Aceleration: float = 500.0

@export var BoostScript: Node
@export var animacion: AnimatedSprite2D
@export var sprite: Sprite2D
@export var LevelMusic: Node
var ChaseMusic

var minWater: float = 0.0
var MaxWater: float = 50.0
var ActualWater: float
var WaterAmount = false
var scaleamount: int = 0
var incremental: float=50.0

var MaxEnhance: bool = false

var CurrentScale

var Input_Dir

signal dash

signal WaterChange(Water)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animacion.hide()
	ChaseMusic = get_tree().get_first_node_in_group("Chase")
	ActualWater = minWater

	if GameManager.has_checkpoint():
		$Variables/PlayerSaveComponent.load_player(self)

	WaterChange.emit(ActualWater)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	CurrentScale = Vector2(scale.x, scale.y)
	if MaxEnhance == true:
		WaterAmount = false
	if ActualWater >= MaxWater:
		WaterAmount = false
		ActualWater = 0.0
		MaxWater += incremental
		BoostScript.MaxBoost += incremental
		WaterChange.emit(ActualWater)
		scaleamount+=1
		var tweenscale = create_tween()
		if scaleamount == 1:
			tweenscale.tween_property(self, "scale", Vector2(1.0, 1.5), 0.5)
		if scaleamount == 2:
			tweenscale.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5)
		if scaleamount == 3:
			tweenscale.tween_property(self, "scale", Vector2(2.0, 2.5), 0.5)
			scaleamount = 3
			MaxEnhance = true
	
	Input_Dir = Input.get_vector("A", "D", "W", "S").normalized()
	if Input.is_action_just_pressed("Dash"):
		dash.emit()
	if Input.is_action_just_pressed("Salir"):
		get_tree().quit()
	move_and_slide()

func morir():
	sprite.hide()
	animacion.show()
	animacion.play("marchitarse")
	await animacion.animation_finished
	sprite.show()
	if !is_inside_tree():
		return
	get_tree().reload_current_scene()
	
