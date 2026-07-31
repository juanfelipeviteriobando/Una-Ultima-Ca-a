extends Node

@export var MaxBoost: float = 100.0
@export var MinBoost: float = 0.0
@export var ActualBoost: float = 50.0

signal BoostLose(LosedPoint: float)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActualBoost = MaxBoost


func LoseBoost(LosePoint):
	ActualBoost -= LosePoint
	BoostLose.emit(ActualBoost)

	
	if ActualBoost <= MinBoost:
		ActualBoost = MinBoost
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("Noquear"):
		body.Noquear()
