extends CanvasLayer

@export var BoostBar: TextureProgressBar
@export var StateMachine: Node
@export var BoostScript: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BoostScript.has_signal("BoostLose"):
		BoostScript.BoostLose.connect(SignalBoost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SignalBoost(ActualBoost: float):
	print("Fuck you")
	BoostBar.value = ActualBoost
