extends Spatial

func _ready() -> void:
	$PivotMesh.set_as_toplevel(true)

func compare_eq(f1: float, f2: float, eps=1.0):
	return abs(f1 - f2) < eps


func tilt():
	var target_angle = 30.0 if compare_eq(rotation_degrees.x, -30.0) else -30.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees:x", target_angle, 1.0)
	tween.play()
