extends Control



func _process(delta: float) -> void:
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second())
