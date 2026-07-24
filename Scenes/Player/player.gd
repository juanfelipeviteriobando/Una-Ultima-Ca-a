extends CharacterBody2D

@export var Sprite: Sprite2D
@export var Speed: float = 150.0
@export var Friction: float = 1200.0
@export var Aceleration: float = 500.0

var Input_Dir
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	Input_Dir = Input.get_vector("A", "D", "W", "S").normalized()
	move_and_slide()
