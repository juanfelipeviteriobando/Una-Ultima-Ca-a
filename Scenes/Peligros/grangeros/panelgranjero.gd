extends Panel

@onready var estado_label = $VBoxContainer/Label
@onready var sospecha_label = $VBoxContainer/Label2
@onready var tiempo_label = $VBoxContainer/Label3
@onready var objetivo_label = $VBoxContainer/Label4
@onready var velocidad_label = $VBoxContainer/Label5


var granjero


func _ready():
	granjero = get_parent()


func _process(delta):
	if granjero == null:
		return

	actualizar_interfaz()


func actualizar_interfaz():

	# Estado actual
	estado_label.text = "Estado: " + \
	str(granjero.EstadoIA.keys()[granjero.estado_actual])


	# Nivel de sospecha
	sospecha_label.text = "Sospecha: " + \
	str(granjero.nivel_sospecha) + "/3"


	# Tiempo en estado
	tiempo_label.text = "Tiempo estado: " + \
	str(snapped(granjero.tiempo_estado, 0.1)) + "s"


	# Objetivo
	if granjero.player:
		objetivo_label.text = "Objetivo: Player"
	else:
		objetivo_label.text = "Objetivo: Ninguno"


	# Velocidad
	velocidad_label.text = "Velocidad: " + \
	str(snapped(granjero.velocity.length(), 1))
