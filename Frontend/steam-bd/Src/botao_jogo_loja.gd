extends Button
class_name BotaoJogoLoja

@onready var nomeLabel: Label = $HBoxContainer/Label
@onready var precoLabel: Label = $Label

func setup(nomeJogo : String, simbolo : String, preco : float):
	nomeLabel.text = nomeJogo
	preco = snapped(preco, 0.01)
	var precoStr = simbolo + " " + str(preco)
	precoLabel.text = precoStr
