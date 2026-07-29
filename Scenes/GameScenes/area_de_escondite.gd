extends Node2D
@export var Porcentague_de_lentitud:float=0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_collision_layer_value(3, false)
		body.set_collision_layer_value(5, true)
		body.Speed=body.Speed*Porcentague_de_lentitud


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_collision_layer_value(3, true)
		body.set_collision_layer_value(5, false)
		body.Speed=body.Speed/Porcentague_de_lentitud
