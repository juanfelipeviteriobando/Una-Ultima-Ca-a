extends Node

@export var minWater: float = 0.0
@export var MaxWater: float = 50.0
@export var ActualWater: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActualWater = minWater

func AddWater(WaterAmount):
	ActualWater += WaterAmount
	
	
	if ActualWater >= MaxWater:
		ActualWater = minWater
		MaxWater += 50.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
