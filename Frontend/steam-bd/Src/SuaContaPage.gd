extends Panel

@onready var nickname: LineEdit = $VBoxContainer/LineEdit
@onready var email: LineEdit = $VBoxContainer/LineEdit2
@onready var ehPremium: Label = $VBoxContainer/Label4

var carregado = false

func _draw() -> void:
	if carregado: return
	carregado = true
	var url = Controller.url + "/consumers/" + str(Controller.id_consumidor)
	NetworkManager.make_request(url, callback, HTTPClient.METHOD_GET, [], '')


func callback(result, code, headers, body):
	if code == 200:
		var data = NetworkManager.returnData(body)
		nickname.text = data['nickname']
		email.text = data['email']
		if data['eh_premium']:
			ehPremium.text = 'SIM'
			ehPremium.self_modulate = Color.GREEN
		else:
			ehPremium.text = 'NÃO'
			ehPremium.self_modulate = Color.RED


func atualizar_info() -> void:
	var body = {
		"nickname": nickname.text,
		"email": email.text
	}
	var url = Controller.url + "/consumers/" + str(Controller.id_consumidor)
	NetworkManager.make_request(url, attCallback, HTTPClient.METHOD_PUT, ["Content-Type: application/json"], JSON.stringify(body))

func attCallback(result, code, headers, body):
	var url = Controller.url + "/consumers/" + str(Controller.id_consumidor)
	NetworkManager.make_request(url, callback, HTTPClient.METHOD_GET, [], '')
