extends CharacterBody2D

@export var Sprite: Sprite2D
@export var Speed: float = 150.0
@export var Friction: float = 1200.0
@export var Aceleration: float = 500.0


var minWater: float = 0.0
var MaxWater: float = 50.0
var ActualWater: float
var WaterAmount = false
var scaleamount: int = 0

var CurrentScale

var Input_Dir

signal dash

signal WaterChange(Water)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActualWater = minWater
	WaterChange.emit(ActualWater)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	CurrentScale = Vector2(scale.x, scale.y)
	if WaterAmount == true:
		ActualWater += 0.1
		WaterChange.emit(ActualWater)
	if ActualWater >= MaxWater:
		WaterAmount = false
		ActualWater = 0.0
		MaxWater += 50.0
		WaterChange.emit(ActualWater)
		var tweenscale = create_tween()
		if scaleamount == 1:
			tweenscale.tween_property(self, "scale", Vector2(1.0, 1.5), 0.5)
		if scaleamount == 2:
			tweenscale.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5)
		if scaleamount == 3:
			tweenscale.tween_property(self, "scale", Vector2(2.0, 2.5), 0.5)
	
	Input_Dir = Input.get_vector("A", "D", "W", "S").normalized()
	if Input.is_action_just_pressed("Dash"):
		dash.emit()
	move_and_slide()
