extends Control

func _ready() -> void:
	Game.text_screen_ui = self

func set_text(text):
	$"%Label".text = text
