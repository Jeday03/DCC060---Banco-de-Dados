extends VBoxContainer

const TELA_LOGIN = preload("uid://duh5maitd0kw2")
@onready var email: LineEdit = $LineEdit
@onready var senha: LineEdit = $LineEdit2
@onready var senha2: LineEdit = $LineEdit3

func voltar_pressed() -> void:
	SceneController.changeSceneTo(TELA_LOGIN)

func cadastro_pressed() -> void:
	pass # Replace with function body.
