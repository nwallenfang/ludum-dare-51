extends Control


func _ready() -> void:
	for button in $VBoxContainer/GridContainer.get_children():
		button.connect("clicked", self, "_on_HoverButton_clicked")

	for button in $VBoxContainer/GridContainer2.get_children():
		if not button.name.begins_with("Gap"):
			button.connect("clicked", self, "_on_HoverButton_clicked")


func _on_HoverButton_clicked(level_index) -> void:
	Game.world.load_level(level_index)


func _on_Button_pressed() -> void:
	Ui.hide_level_select()
