extends Area2D
@export var azucar:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	hide()
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.disabled = true
	monitoring = false
	monitorable = false
	set_collision_mask_value(3, false)
	body.BoostScript.LoseBoost(-azucar)
	$Timer.start()


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	show()
	$CollisionShape2D.disabled = false
	monitoring = true
	monitorable = true
	set_collision_mask_value(3, true)
