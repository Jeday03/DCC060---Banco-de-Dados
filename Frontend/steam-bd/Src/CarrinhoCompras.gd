extends Node

var listaIds : Array[int] = []
signal alterouLista(size : int)

func adicionar(id):
	if listaIds.has(id): return
	listaIds.append(id)
	alterouLista.emit(listaIds.size())

func remover(id):
	listaIds.erase(id)

func finalizarCompra():
	
	pass
