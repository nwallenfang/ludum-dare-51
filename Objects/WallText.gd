extends Spatial

#func set_text(text):
#	Game.text_screen_ui.set_text(text)
	
	
func set_texture(viewport: Viewport):
	if viewport == null:
		return

	var viewport_tex: ViewportTexture = viewport.get_texture()
	viewport_tex.viewport_path = NodePath("/root/World/Viewport2D")

	$Screen.get_active_material(0).albedo_texture = viewport_tex


func _ready() -> void:
	Game.connect("viewport_texture_changed", self, "set_texture")

