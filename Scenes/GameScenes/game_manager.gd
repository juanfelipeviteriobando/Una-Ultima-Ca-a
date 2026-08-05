extends Node


var checkpoint_data: Dictionary = {}


func save_checkpoint(data: Dictionary):
	for key in data:
		checkpoint_data[key] = data[key]
	print("Checkpoint guardado:", checkpoint_data)


func has_checkpoint() -> bool:
	return not checkpoint_data.is_empty()


func get_checkpoint_data() -> Dictionary:
	return checkpoint_data


func clear_checkpoint():
	checkpoint_data.clear()
