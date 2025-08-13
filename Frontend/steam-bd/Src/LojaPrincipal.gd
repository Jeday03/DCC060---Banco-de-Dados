extends Panel

var listaJogos = []
@onready var containerJogos: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer
const BOTAO_JOGO_LOJA = preload("uid://cdwg6ryp5yp3i")

var carregado = false

func _on_draw() -> void:
	if carregado: return
	carregado = true
	NetworkManager.make_request(Controller.url + "/jogos", pegaJogos, HTTPClient.METHOD_GET, [], '')

func pegaJogos(result, code, headers, body):
	var data = NetworkManager.returnData(body)
	listaJogos = data
	print(data)
	for jogo in listaJogos:
		var b : BotaoJogoLoja = BOTAO_JOGO_LOJA.instantiate() as BotaoJogoLoja
		containerJogos.add_child(b)
		b.setup(jogo['id_jogo'], jogo['titulo'], Controller.simbolo_montario, float(jogo['preco_dolar']) * Controller.cambio)
