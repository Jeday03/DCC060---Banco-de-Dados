extends VBoxContainer

const TELA_REGISTRO = preload("uid://tq1ftj6i44qk")
const APLICACAO = preload("uid://bvqec7yaqmxpy")

const url = "http://127.0.0.1:5000/consumer-login"

@onready var email: LineEdit = $LineEdit
@onready var senha: LineEdit = $LineEdit2
@onready var msg: Label = $msg

func registrar_pressed() -> void:
	SceneController.changeSceneTo(TELA_REGISTRO, "Diamond", "Diamond")

func login_pressed() -> void:
	var body = {
		"email": email.text,
		"senha": senha.text
	}
	NetworkManager.make_request(url, httpRetorno, HTTPClient.METHOD_POST, ["Content-Type: application/json"], JSON.stringify(body))

func httpRetorno(result, code, headers, body):
	if code == 200:
		var response_data = NetworkManager.returnData(body)
		print(response_data)
		Controller.id_consumidor = response_data['id_consumidor']
		Controller.id_pais = response_data['id_pais']
		Controller.id_usuario = response_data['id_usuario']
		Controller.cambio = response_data['razao_cambio']
		Controller.nickname = response_data['nickname']
		Controller.simbolo_montario = response_data['simbolo_moeda']
		SceneController.changeSceneTo(APLICACAO)
	else:
		msg.visible = true
	pass
