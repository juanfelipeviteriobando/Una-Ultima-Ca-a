extends Control

@export var total_collectibles := 4

@onready var label = $Label

func _ready():
	var conseguidos := 0
	var nombres := ""

	if GameManager.has_checkpoint():
		var data = GameManager.get_checkpoint_data()

		if data.has("collectibles"):
			conseguidos = data["collectibles"].size()

			for collectible in data["collectibles"]:
				nombres += "- " + str(collectible) + "\n"

	if nombres == "":
		nombres = "Ninguno"

	label.text = "Coleccionables: %d/%d\n\nConseguidos:\n%s" % [conseguidos, total_collectibles, nombres]
