extends Area2D

@export var collectible_id:String

func _ready():
	body_entered.connect(_on_body_entered)

	# Si ya fue recogido anteriormente, desaparece
	if GameManager.has_checkpoint():
		var data = GameManager.get_checkpoint_data()

		if data.has("collectibles"):
			if data["collectibles"].has(collectible_id):
				queue_free()

func _on_body_entered(body):

	if !body.is_in_group("Player"):
		return

	var data = {}

	if GameManager.has_checkpoint():
		data = GameManager.get_checkpoint_data()

	if !data.has("collectibles"):
		data["collectibles"] = []

	if !data["collectibles"].has(collectible_id):
		data["collectibles"].append(collectible_id)

	GameManager.save_checkpoint(data)

	queue_free()
