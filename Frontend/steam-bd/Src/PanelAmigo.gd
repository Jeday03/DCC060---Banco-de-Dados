extends Panel
class_name PanelAmigo

@onready var label: Label = $Label

func setup(nomeAmigo):
	if not label: 
		print("Não achei o label")
		return
	label.text = nomeAmigo
