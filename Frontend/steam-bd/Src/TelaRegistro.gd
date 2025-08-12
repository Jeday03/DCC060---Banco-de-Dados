extends VBoxContainer

const TELA_LOGIN = preload("uid://duh5maitd0kw2")
@onready var email: LineEdit = $LineEdit
@onready var senha: LineEdit = $LineEdit2
@onready var senha2: LineEdit = $LineEdit3
@onready var nickname: LineEdit = $LineEdit4

@onready var boa_mensagem: Label = $BoaMensagem
@onready var ruim_mensagem: Label = $RuimMensagem

const url = ""

func voltar_pressed() -> void:
	SceneController.changeSceneTo(TELA_LOGIN)

func cadastro_pressed() -> void:
	boa_mensagem.visible = false
	ruim_mensagem.visible = false
	if(senha.text != senha2.text): 
		callback(0, 0, [], {})
		return
	var body = {
		"email": email.text,
		"senha": senha.text,
		"nickname": nickname.text
	}
	NetworkManager.make_request(url, callback, HTTPClient.METHOD_PUT, ["Content-Type: application/json"], body)
	pass # Replace with function body.

func callback(result, response_code, headers, body):
	if response_code == 200:
		boa_mensagem.visible = true
		var clock = get_tree().create_timer(1)
		await clock.timeout
		SceneController.changeSceneTo(TELA_LOGIN)
	else:
		ruim_mensagem.visinle = true
