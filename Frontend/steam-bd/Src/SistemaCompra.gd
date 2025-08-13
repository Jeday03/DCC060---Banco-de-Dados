extends Control
class_name SistemaDeCompra

const PANEL_COMPRA_JOGO = preload("uid://c8aplugm1rl8w")

@onready var container: VBoxContainer = $MarginContainer/HBoxContainer/Panel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer

@onready var precoTotalLabel: Label = $MarginContainer/HBoxContainer/Panel/VBoxContainer/Label2
@onready var compraFinalizada: Label = $MarginContainer/HBoxContainer/Panel2/VBoxContainer/Label3
@onready var tenteNovamente: Label = $MarginContainer/HBoxContainer/Panel2/VBoxContainer/Label4

var total : float = 0

func abrir():
	visible = true
	var url = Controller.url + "/games/bulk?ids="
	for i in CarrinhoCompras.listaIds:
		url += str(i) + ","
	url = url.left(url.length() - 1)
	NetworkManager.make_request(url, callbackAbrir, HTTPClient.METHOD_GET, [], '')

func callbackAbrir(result, code, headers, body):
	var data = NetworkManager.returnData(body)
	for d in data['games']:
		var p : PanelCompraJogo = PANEL_COMPRA_JOGO.instantiate() as PanelCompraJogo
		container.add_child(p)
		p.setup(d)
		#total += snapped(d['preco_dolar'] * Controller.cambio, 0.01)
	precoTotalLabel.text = "Preço total: " + Controller.simbolo_montario + " " + str(total)

func terminar_compra_pressed() -> void:
	var url = Controller.url + "/users/" + str(Controller.id_usuario) + "/games/bulk"
	var body = {
		"jogos": CarrinhoCompras.listaIds
	}
	print(JSON.stringify(body))
	NetworkManager.make_request(url, callback_finalizar, HTTPClient.METHOD_POST, ["Content-Type: application/json"],JSON.stringify(body))

func callback_finalizar(result, code, headers, body):
	if code == 201:
		compraFinalizada.visible = true
		tenteNovamente.visible = false
	else:
		tenteNovamente.visible = true

func voltar_pressed() -> void:
	compraFinalizada.visible = false
	tenteNovamente.visible = false
	visible = false
	for child in container.get_children():
		child.queue_free()
