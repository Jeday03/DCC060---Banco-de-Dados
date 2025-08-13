extends VBoxContainer

const TELA_LOGIN = preload("uid://duh5maitd0kw2")
@onready var email: LineEdit = $LineEdit
@onready var senha: LineEdit = $LineEdit2
@onready var senha2: LineEdit = $LineEdit3
@onready var nickname: LineEdit = $LineEdit4
@onready var pais: OptionButton = $OptionButton
@onready var nome: LineEdit = $LineEdit5

@onready var boa_mensagem: Label = $BoaMensagem
@onready var ruim_mensagem: Label = $RuimMensagem

const url = "http://127.0.0.1:5000/users"

func _ready() -> void:
	print("Tela login eh ", TELA_LOGIN)

func voltar_pressed() -> void:
	get_tree().change_scene_to_packed(TELA_LOGIN)

func cadastro_pressed() -> void:
	boa_mensagem.visible = false
	ruim_mensagem.visible = false
	if(senha.text != senha2.text): 
		callback(0, 0, [], {})
		return
	var body = {
		"email": email.text,
		"senha": senha.text,
		"nickname": nickname.text,
		"id_pais": pais.get_selected_id(),
		"nome": nome.text
	}

	var json_string = JSON.stringify(body)

	NetworkManager.make_request(url, callback, HTTPClient.METHOD_POST, ["Content-Type: application/json"], json_string)
	pass # Replace with function body.

func callback(result, response_code, headers, body):
	if response_code == 201:
		boa_mensagem.visible = true
		var clock = get_tree().create_timer(1)
		await clock.timeout
		SceneController.changeSceneTo(TELA_LOGIN, "Diamond", "Diamond")
	else:
		ruim_mensagem.visible = true
