extends MarginContainer

@onready var container: VBoxContainer = $HBoxContainer/Panel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var precoTotalLabel: Label = $HBoxContainer/Panel/VBoxContainer/Label2
const PANEL_COMPRA_JOGO = preload("uid://c8aplugm1rl8w")

var total : float = 0

func abrir():
	var url = Controller.url + "/games/bulk?="
	for i in CarrinhoCompras.listaIds:
		url += str(i) + ","
	NetworkManager.make_request(url, callbackAbrir, HTTPClient.METHOD_GET, [], '')

func callbackAbrir(result, code, headers, body):
	var data = NetworkManager.returnData(body)
	for d in data:
		var p : PanelCompraJogo = PANEL_COMPRA_JOGO.instantiate() as PanelCompraJogo
		container.add_child(p)
		p.setup(d)
		total += snapped(d['preco_dolar'] * Controller.cambio, 0.01)
	precoTotalLabel.text = "Preço total: " + Controller.simbolo_montario + " " + str(total)
