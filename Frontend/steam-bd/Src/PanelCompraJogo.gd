extends Panel
class_name PanelCompraJogo

var id_jogo : int
@onready var titulo: Label = $HBoxContainer/Label
@onready var precoLabel: Label = $HBoxContainer2/Label

func setup(data):
	id_jogo = data['id_jogo']
	titulo.text = data['titulo']
	var precoAtual = Controller.cambio * float(data['preco_dolar'])
	precoAtual = snapped(precoAtual, 0.01)
	precoLabel.text = Controller.simbolo_montario + " " + str(precoAtual)

func _on_button_pressed() -> void:
	CarrinhoCompras.remover(id_jogo)
	queue_free()
