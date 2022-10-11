extends Control
tool
export var level_screenshot: Texture
export var level_name: String
export var level_index: int


onready var style_box_default: StyleBoxFlat = preload("res://UI/Styles/panel.tres")
var style_box_hovered: StyleBoxFlat = preload("res://UI/Styles/panel_menu_button_hovered.tres")

func _ready() -> void:	
	$Panel.set("shader_param/level_image", level_screenshot)
	$Panel/CenterContainer/Label.text = level_name

signal clicked
func _on_Panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton

		if event.pressed:
			emit_signal("clicked", level_index)

func _on_Panel_mouse_entered() -> void:
	$Panel.set("custom_styles/panel", style_box_hovered)


func _on_Panel_mouse_exited() -> void:
	$Panel.set("custom_styles/panel", style_box_default)
