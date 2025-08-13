extends Panel

@onready var amigoContainer: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
const PANEL_AMIGO = preload("uid://bh6045w6hindy")
@onready var line_nickname: LineEdit = $MarginContainer/VBoxContainer/Control/LineEdit

var carregado = false

func _draw() -> void:
	if carregado: return
	carregado = true
	var url = Controller.url + "/users/" + str(Controller.id_usuario) + "/friends"
	NetworkManager.make_request(url, drawAmigos, HTTPClient.METHOD_GET, [], '')

func drawAmigos(result, code, headers, body):
	var data = NetworkManager.returnData(body)
	for a in data:
		var p : PanelAmigo = PANEL_AMIGO.instantiate() as PanelAmigo
		amigoContainer.add_child(p)
		p.setup(a['nickname'])

func adicionar_amigo_pressed() -> void:
	var body = {
		"nickname": line_nickname.text
	}
	var url = Controller.url + "/users/" + str(Controller.id_usuario) + "/friends"
	NetworkManager.make_request(url, adicionouAmigo, HTTPClient.METHOD_POST, ["Content-Type: application/json"], JSON.stringify(body))

func adicionouAmigo(result, code, headers, body):
	if code == 201:
		var url = Controller.url + "/users/" + str(Controller.id_usuario) + "/friends"
		NetworkManager.make_request(url, drawAmigos, HTTPClient.METHOD_GET, [], '')
