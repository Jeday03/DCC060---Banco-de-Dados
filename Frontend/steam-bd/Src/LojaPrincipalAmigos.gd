extends Panel

var listaJogos = []
const BOTAO_JOGO_LOJA = preload("uid://cdwg6ryp5yp3i")
@onready var container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer

var carregado = false

func _on_draw() -> void:
	if carregado: return
	carregado = true
	NetworkManager.make_request(Controller.url + "/users/" + str(Controller.id_usuario) + "/friends/games", callback, HTTPClient.METHOD_GET, [], '')

func callback(result, code, headers, body):
	var data = NetworkManager.returnData(body)
	listaJogos = data
	for jogo in listaJogos:
		var b : BotaoJogoLoja = BOTAO_JOGO_LOJA.instantiate() as BotaoJogoLoja
		container.add_child(b)
		b.setup(jogo['titulo'], Controller.simbolo_montario, float(jogo['preco_dolar']) * Controller.cambio, jogo['nickname_amigo'])
