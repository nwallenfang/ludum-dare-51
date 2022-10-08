extends Control



func _on_HoverButton_clicked(level_name) -> void:
	var level_index = int(level_name) - 1
	Game.world.load_level(level_index)
