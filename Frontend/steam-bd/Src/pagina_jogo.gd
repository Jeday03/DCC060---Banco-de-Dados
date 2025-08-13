extends Control
class_name PaginaJogo

var id_jogo = 0

@onready var titulo_label: Label = $MarginContainer/VBoxContainer/TituloLabel
@onready var desc: RichTextLabel = $MarginContainer/VBoxContainer/desc
@onready var coment_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

const COMENTARIO = preload("uid://2yxv7hd2hj4s")
@onready var text_edit: TextEdit = $MarginContainer/VBoxContainer/Control/TextEdit

func _ready() -> void:
	Controller.paginaJogo = self as PaginaJogo

func setup(data):
	visible = true
	titulo_label.text = data['titulo']
	desc.text = data['descricao']
	id_jogo = data['id_jogo']
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

func recarregaComentarios(result, code, headers, body):
	NetworkManager.make_request(Controller.url + "/games/" + str(id_jogo) + "/comments", carregaComentarios, HTTPClient.METHOD_GET, [], '')
