extends Control
class_name PaginaJogo

var id_jogo : int = 0

@onready var titulo_label: Label = $MarginContainer/VBoxContainer/TituloLabel
@onready var desc: RichTextLabel = $MarginContainer/VBoxContainer/desc
@onready var coment_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var preco_label: Label = $MarginContainer/VBoxContainer/PrecoLabel

const COMENTARIO = preload("uid://2yxv7hd2hj4s")
@onready var text_edit: TextEdit = $MarginContainer/VBoxContainer/Control/TextEdit

func _ready() -> void:
	Controller.paginaJogo = self as PaginaJogo

func setup(data):
	visible = true
	titulo_label.text = data['titulo']
	desc.text = data['descricao']
	id_jogo = data['id_jogo']
	var precoAtual = Controller.cambio * float(data['preco_dolar'])
	precoAtual = snapped(precoAtual, 0.01)
	preco_label.text = Controller.simbolo_montario + " " + str(precoAtual)
	var url = Controller.url + "/games/" + str(int(data['id_jogo'])) + "/comments"
	print("url", url)
	NetworkManager.make_request(url, carregaComentarios, HTTPClient.METHOD_GET, [], '')

func carregaComentarios(result, code, headers, body):
	for child in coment_container.get_children():
		child.queue_free()
	var comentarios = NetworkManager.returnData(body)
	print(comentarios)
	for c in comentarios:
		var inst = COMENTARIO.instantiate()
		coment_container.add_child(inst)
		inst.setup(c['nickname'], c['texto'])

func _on_button_pressed() -> void:
	var body = {
		"id_usuario": Controller.id_usuario,
		"texto": text_edit.text
	}
	NetworkManager.make_request(Controller.url + "/games/" + str(id_jogo) + "/comments", recarregaComentarios, HTTPClient.METHOD_POST,  ["Content-Type: application/json"], JSON.stringify(body))
	text_edit.text = ""

func recarregaComentarios(result, code, headers, body):
	var url = Controller.url + "/games/" + str(id_jogo) + "/comments"
	print("url", url)
	NetworkManager.make_request(url, carregaComentarios, HTTPClient.METHOD_GET, [], '')

func voltar_pressed() -> void:
	visible = false
	text_edit.text = ""
