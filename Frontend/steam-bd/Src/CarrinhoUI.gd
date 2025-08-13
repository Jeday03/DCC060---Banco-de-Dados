extends HBoxContainer

@onready var label: Label = $Label
@onready var sistema_de_compra: SistemaDeCompra = $"../../SistemaDeCompra"

func _ready() -> void:
	CarrinhoCompras.alterouLista.connect(atualizaLabel)

func atualizaLabel(valor : int):
	label.text = str(valor) + " itens"

func pagar_compra() -> void:
	sistema_de_compra.abrir()
