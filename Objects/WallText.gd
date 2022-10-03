extends Spatial

var viewport_material: SpatialMaterial
var fixed_materials = []
var screen_materials = []

onready var screen = $Screen
	
func set_texture(viewport: Viewport):
	if viewport == null:
		return

	var viewport_tex: ViewportTexture = viewport.get_texture()
	viewport_tex.viewport_path = NodePath("/root/World/Viewport2D")

	viewport_material.albedo_texture = viewport_tex
	
	screen_materials.clear()
	screen_materials = fixed_materials.duplicate()
	screen_materials.append(viewport_material)


func new_event_triggered(event):
	screen.material_override = viewport_material


func _ready() -> void:
	viewport_material = $Screen.get_active_material(0).duplicate()
	Game.connect("viewport_texture_changed", self, "set_texture")
	Events.connect("trigger_event", self, "new_event_triggered")

