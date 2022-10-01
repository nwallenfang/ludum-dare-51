extends ImmediateGeometry


func _ready():
	pass

func draw_line(p1: Vector3, p2: Vector3):
	var direction := p1.direction_to(p2)
	var normale := Vector3.UP.cross(direction).cross(direction).normalized()
	var width := .65
	
	
	begin(Mesh.PRIMITIVE_TRIANGLES)
	
	set_uv(Vector2(0.0, 0.0))
	add_vertex(p1 + normale * width)
	set_uv(Vector2(0.0, 1.0))
	add_vertex(p1 - normale * width)
	set_uv(Vector2(1.0, 0.0))
	add_vertex(p2 + normale * width)
	
	set_uv(Vector2(1.0, 0.0))
	add_vertex(p2 + normale * width)
	set_uv(Vector2(1.0, 1.0))
	add_vertex(p2 - normale * width)
	set_uv(Vector2(0.0, 1.0))
	add_vertex(p1 - normale * width)
	
	end()
	
	$Tween.interpolate_property(material_override, "shader_param/albedo:a", 1.0, 0.0, .65, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()
	
#	begin(Mesh.PRIMITIVE_LINES)
#
#	add_vertex(p1)
#	add_vertex(p2)
#
#	end()
#
#	yield(get_tree().create_timer(0.2), "timeout")
#	queue_free()
