extends HBoxContainer

@onready var label: Label = $Label

func _ready() -> void:
	CarrinhoCompras.alterouLista.connect(atualizaLabel)

func atualizaLabel(valor : int):
	label.text = str(valor) + " itens"
