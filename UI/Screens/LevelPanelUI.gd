extends Control

func _on_HoverButton_clicked(level_index) -> void:
	Game.world.load_level(level_index)
