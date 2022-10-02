extends Spatial


func set_texture(viewport: Viewport):
	print("yup")

	

	var viewport_tex: ViewportTexture = viewport.get_texture()
	viewport_tex.viewport_path = NodePath("/root/World/Viewport2D")
	print("path: ", viewport_tex.viewport_path)
	$Screen.get_active_material(0).albedo_texture = viewport_tex


func _ready() -> void:
	Game.connect("viewport_texture_changed", self, "set_texture")
