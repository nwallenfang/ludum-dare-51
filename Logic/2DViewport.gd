extends Viewport


func _ready() -> void:
	yield(get_tree().create_timer(0.5), "timeout")

	var viewport_tex = get_texture()
#	print("path: ", viewport_tex.viewport_path)
#	Game.viewport_texture = viewport_tex
