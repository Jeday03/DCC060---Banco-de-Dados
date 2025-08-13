extends Button
class_name BotaoJogoLoja

var id_jogo : int

@onready var nomeLabel: Label = $HBoxContainer/Label
@onready var precoLabel: Label = $Label
@onready var amigoLabel: Label = $HBoxContainer/Label2

func setup(_id_jogo: int, nomeJogo : String, simbolo : String, preco : float, amigo : String = ''):
	nomeLabel.text = nomeJogo
	id_jogo = _id_jogo
	preco = snapped(preco, 0.01)
	var precoStr = simbolo + " " + str(preco)
	precoLabel.text = precoStr
	if amigo != '':
		amigoLabel.text = "De: " + amigo

func _on_pressed() -> void:
	Controller.abrirPagina(id_jogo)

func comprar_pressed() -> void:
	CarrinhoCompras.adicionar(id_jogo)
