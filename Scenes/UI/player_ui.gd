extends CanvasLayer

@export_category("Boost")
@export var BoostBar: TextureProgressBar
@export var BoostScript: Node

@export_category("Water")
@export var WaterBar: TextureProgressBar
@export var Player: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BoostScript.has_signal("BoostLose"):
		BoostScript.BoostLose.connect(SignalBoost)
	if Player.has_signal("WaterChange"):
		Player.WaterChange.connect(WaterChange)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SignalBoost(ActualBoost: float):
	BoostBar.value = ActualBoost

func WaterChange(ActualWater: float):
	WaterBar.value = ActualWater
