extends Panel

@onready var label: Label = $VBoxContainer/Panel/Label
@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel

func setup(nickname, texto):
	label.text = nickname
	rich_text_label.text = texto
