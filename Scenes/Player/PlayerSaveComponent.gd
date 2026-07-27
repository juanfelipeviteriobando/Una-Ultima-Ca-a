extends Node


func save_player(player: Node):
	var data := {}

	# Datos básicos
	data["position"] = player.global_position
	data["scale"] = player.scale

	# Datos de crecimiento
	data["scaleamount"] = player.scaleamount
	data["max_enhance"] = player.MaxEnhance

	# Agua
	data["actual_water"] = player.ActualWater
	data["max_water"] = player.MaxWater

	# Boost
	if player.BoostScript:
		data["max_boost"] = player.BoostScript.MaxBoost


	GameManager.save_checkpoint(data)



func load_player(player: Node):
	var data = GameManager.get_checkpoint_data()

	if data.is_empty():
		return


	# Posición
	if data.has("position"):
		player.global_position = data["position"]


	# Escala
	if data.has("scale"):
		player.scale = data["scale"]


	# Crecimiento
	if data.has("scaleamount"):
		player.scaleamount = data["scaleamount"]

	if data.has("max_enhance"):
		player.MaxEnhance = data["max_enhance"]


	# Agua
	if data.has("actual_water"):
		player.ActualWater = data["actual_water"]

	if data.has("max_water"):
		player.MaxWater = data["max_water"]


	# Boost
	if data.has("max_boost") and player.BoostScript:
		player.BoostScript.MaxBoost = data["max_boost"]



# Para añadir datos externos sin tocar este script
func add_save_data(key:String, value):
	var data = GameManager.get_checkpoint_data()
	data[key] = value
	GameManager.save_checkpoint(data)



func get_save_data(key:String, default=null):
	var data = GameManager.get_checkpoint_data()
	return data.get(key, default)
