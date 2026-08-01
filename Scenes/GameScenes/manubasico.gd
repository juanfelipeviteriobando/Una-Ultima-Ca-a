extends MenuButton

func _ready():
	var menu = get_popup()

	menu.add_item("Nueva partida", 0)
	menu.add_item("Guardar", 1)
	menu.add_item("Salir", 2)

	menu.id_pressed.connect(menu_seleccionado)


func menu_seleccionado(id):
	match id:
		0:
			print("Nueva partida")
		1:
			print("Guardando...")
		2:
			get_tree().quit()
