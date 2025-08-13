extends Node

const url = "http://127.0.0.1:5000"

var id_consumidor : int
var id_usuario : int
var nickname : String
var id_pais : int
var simbolo_montario : StringName
var cambio : float

var paginaJogo : PaginaJogo = null

func abrirPagina(id_jogo):
	NetworkManager.make_request(url + "/games/" + str(id_jogo), carregarPagina, HTTPClient.METHOD_GET, [], '')

func carregarPagina(result, code, headers, body):
	var data = NetworkManager.returnData(body)
	paginaJogo.setup(data)
	pass
