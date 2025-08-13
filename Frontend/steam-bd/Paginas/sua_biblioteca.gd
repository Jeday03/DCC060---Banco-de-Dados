extends Panel

const PANEL_BIBLIOTECA = preload("res://Prefabs/panel_biblioteca.tscn")
@onready var container: VBoxContainer = $MarginContainer/VBoxContainer

func _on_visibility_changed() -> void:
	if visible:
		var url = Controller.url + "/users/" + str(Controller.id_usuario) + "/purchases"
		NetworkManager.make_request(url, callback, HTTPClient.METHOD_GET, [], '')

func callback(result, code, headers, body):
	for c in container.get_children():
		c.queue_free()
	var data = NetworkManager.returnData(body)
	for d in data:
		var p : PanelBiblioteca = PANEL_BIBLIOTECA.instantiate() as PanelBiblioteca
		container.add_child(p)
		p.label.text = d['titulo']
		
