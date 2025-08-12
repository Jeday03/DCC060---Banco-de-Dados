extends Node

const url = "http://127.0.0.1:5000"

var id_consumidor : int
var id_usuario : int
var nickname : String
var id_pais : int
var simbolo_montario : StringName
var cambio : float

func abrirPagina(id_jogo):
	NetworkManager.make_request()
