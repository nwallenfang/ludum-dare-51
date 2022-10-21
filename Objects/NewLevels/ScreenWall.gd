extends Spatial




func _ready() -> void:
	Game.connect("viewport_texture_changed", self, "set_texture")
