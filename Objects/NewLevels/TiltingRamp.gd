extends Spatial
tool



func tilt():
	var target_angle = 30.0 if rotation_degrees.x == -30.0 else -30.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees:x", target_angle, 1.0)
	tween.play()
