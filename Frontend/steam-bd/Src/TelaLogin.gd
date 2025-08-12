extends VBoxContainer

const TELA_REGISTRO = preload("uid://tq1ftj6i44qk")
const APLICACAO = preload("uid://bvqec7yaqmxpy")

const url = ""

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
	NetworkManager.make_request(url, httpRetorno, HTTPClient.METHOD_POST, ["Content-Type: application/json"], body)

func httpRetorno(result, code, headers, body):
	if code == 200:
		SceneController.changeSceneTo(APLICACAO)
		print("Login executado com sucesso")
	else:
		msg.visible = true
	pass
